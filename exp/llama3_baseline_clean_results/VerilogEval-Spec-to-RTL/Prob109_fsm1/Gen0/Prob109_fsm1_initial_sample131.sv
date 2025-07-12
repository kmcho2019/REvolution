module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 1-bit state register, could be optimized but shown for clarity
parameter B = 1'b1, A = 1'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            B: state <= (in == 1'b0) ? A : B;
            A: state <= (in == 1'b0) ? B : A;
            default: state <= B; // default state
        endcase
    end
end

assign out = state;

endmodule