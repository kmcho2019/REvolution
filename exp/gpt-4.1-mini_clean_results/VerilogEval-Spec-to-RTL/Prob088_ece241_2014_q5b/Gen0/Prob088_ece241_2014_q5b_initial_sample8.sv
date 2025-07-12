module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

// One-hot encoding for states
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Next state and output logic (Mealy FSM)
always @(*) begin
    case (state)
        A: begin
            z = (x == 1'b1) ? 1'b1 : 1'b0;
            next_state = (x == 1'b1) ? B : A;
        end
        B: begin
            z = (x == 1'b0) ? 1'b1 : 1'b0;
            next_state = B;
        end
        default: begin
            // Should never happen, reset to A
            z = 1'b0;
            next_state = A;
        end
    endcase
end

endmodule