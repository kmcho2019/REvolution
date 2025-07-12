module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

reg [3:0] mux_out;

always @(*) begin
    mux_out[0] = (A == 0) ? Q[0] : Q[4];
    mux_out[1] = (A == 0) ? Q[1] : Q[5];
    mux_out[2] = (A == 0) ? Q[2] : Q[6];
    mux_out[3] = (A == 0) ? Q[3] : Q[7];

    Z = (B == 0 && C == 0) ? mux_out[0] :
        (B == 0 && C == 1) ? mux_out[1] :
        (B == 1 && C == 0) ? mux_out[2] :
        (B == 1 && C == 1) ? mux_out[3] :
        1'bx;
end

endmodule