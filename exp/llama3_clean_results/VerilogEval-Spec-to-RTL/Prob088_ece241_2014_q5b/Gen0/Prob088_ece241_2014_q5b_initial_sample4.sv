module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for states A and B
parameter A = 2'b10, B = 2'b01;

always @(*) begin
    case(state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0; // Default output for invalid states
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Reset to state A
    end else begin
        case(state)
            A: if (x) state <= B; else state <= A;
            B: state <= B; // Stay in B regardless of x
            default: state <= A; // Return to A if in an invalid state
        endcase
    end
end

endmodule