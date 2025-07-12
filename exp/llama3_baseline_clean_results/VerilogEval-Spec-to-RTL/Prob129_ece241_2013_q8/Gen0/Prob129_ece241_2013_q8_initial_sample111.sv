module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;  // Current state of the FSM
reg [1:0] next_state;  // Next state of the FSM

// Define states
parameter IDLE = 2'b00;
parameter ONE_DETECTED = 2'b01;
parameter ZERO_DETECTED = 2'b10;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state <= ONE_DETECTED;
            end else begin
                next_state <= IDLE;
            end
        end
        ONE_DETECTED: begin
            if (~x) begin
                next_state <= ZERO_DETECTED;
            end else begin
                next_state <= ONE_DETECTED;
            end
        end
        ZERO_DETECTED: begin
            if (x) begin
                next_state <= ONE_DETECTED;  // Reset to ONE_DETECTED to recognize overlapping sequences
            end else begin
                next_state <= ZERO_DETECTED;
            end
        end
        default: next_state <= IDLE;
    endcase
end

// Output logic
assign z = (state == ZERO_DETECTED) && x;

endmodule