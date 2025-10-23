module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for the states
parameter A = 2'b01, B = 2'b10; // State encodings

always @(*) begin
    case(state)
        A: z = ~x;
        B: z = ~x;
        default: z = 1'bx; // Invalid state, output don't care
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        case(state)
            A: if(x) state <= B; else state <= A;
            B: state <= B; // Self-loop regardless of x
            default: state <= A; // Reset to A if in an invalid state
        endcase
    end
end

endmodule