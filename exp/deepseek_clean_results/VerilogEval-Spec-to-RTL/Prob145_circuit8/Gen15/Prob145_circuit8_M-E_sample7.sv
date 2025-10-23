module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// State encoding
localparam IDLE    = 2'b00;
localparam CAPTURE = 2'b01;
localparam HOLD    = 2'b10;
localparam RESET   = 2'b11;

reg [1:0] state;
reg a_sampled;

always @(posedge clock) begin
    case(state)
        IDLE: begin
            p <= 0;
            q <= 0;
            if (a_sampled) state <= CAPTURE;
            else state <= IDLE;
        end
        
        CAPTURE: begin
            p <= a;
            q <= 0;
            if (p) state <= HOLD;
            else if (a_sampled) state <= RESET;
            else state <= CAPTURE;
        end
        
        HOLD: begin
            p <= 0;
            q <= 1;
            if (a_sampled) state <= RESET;
            else state <= HOLD;
        end
        
        RESET: begin
            p <= 0;
            q <= 0;
            state <= IDLE;
        end
    endcase
end

// Sample 'a' during low phase
always @(negedge clock) begin
    a_sampled <= a;
end

initial begin
    state = IDLE;
    p = 0;
    q = 0;
    a_sampled = 0;
end

endmodule