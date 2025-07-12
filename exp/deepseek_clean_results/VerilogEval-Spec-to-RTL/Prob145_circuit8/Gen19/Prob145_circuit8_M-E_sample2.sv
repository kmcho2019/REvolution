module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;     // FSM state
reg a_prev;          // Previous value of 'a'
reg clock_prev;      // Previous clock value for edge detection

// State encoding
localparam IDLE = 2'b00;
localparam PULSE = 2'b01;
localparam HOLD = 2'b10;

always @(posedge clock or negedge clock) begin
    clock_prev <= clock;
    
    // Detect clock edges
    case ({clock_prev, clock})
        2'b01: begin // Rising edge
            case (state)
                IDLE: begin
                    if (a && !a_prev) begin
                        p <= 1;
                        state <= PULSE;
                    end
                end
                PULSE: begin
                    p <= 0;
                    state <= HOLD;
                end
                HOLD: begin
                    if (a && !a_prev) begin
                        p <= 1;
                        state <= PULSE;
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
        2'b10: begin // Falling edge
            if (a) begin
                // Reset condition
                p <= 0;
                q <= 0;
                state <= IDLE;
            end else begin
                // Update q on falling edge when p was high
                q <= p;
            end
        end
    endcase
    
    a_prev <= a;
end

initial begin
    state = IDLE;
    p = 0;
    q = 0;
    a_prev = 0;
    clock_prev = 0;
end

endmodule