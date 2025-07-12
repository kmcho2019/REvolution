module TopModule(
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Using a 3-to-8 decoder (implemented as a combination of multiplexers)
// to select the output of one of the 8 flip-flops based on the values of A, B, and C.
always @(Q, A, B, C) begin
    case ({A, B, C})
        3'b000: Z <= Q[0];
        3'b001: Z <= Q[1];
        3'b010: Z <= Q[2];
        3'b011: Z <= Q[3];
        3'b100: Z <= Q[4];
        3'b101: Z <= Q[5];
        3'b110: Z <= Q[6];
        3'b111: Z <= Q[7];
        default: Z <= 1'bx; // Don't care
    endcase
end

endmodule