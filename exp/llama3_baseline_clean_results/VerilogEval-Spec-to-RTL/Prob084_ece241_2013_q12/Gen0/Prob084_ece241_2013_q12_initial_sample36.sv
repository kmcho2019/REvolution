module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

assign Z = (A == 0 && B == 0 && C == 0) ? Q[0] :
            (A == 0 && B == 0 && C == 1) ? Q[1] :
            (A == 0 && B == 1 && C == 0) ? Q[2] :
            (A == 0 && B == 1 && C == 1) ? Q[3] :
            (A == 1 && B == 0 && C == 0) ? Q[4] :
            (A == 1 && B == 0 && C == 1) ? Q[5] :
            (A == 1 && B == 1 && C == 0) ? Q[6] :
            (A == 1 && B == 1 && C == 1) ? Q[7] : 1'bx;

// Alternatively, you can use a case statement for better readability
// assign Z = (A == 0 && B == 0 && C == 0) ? Q[0] :
//             (A == 0 && B == 0 && C == 1) ? Q[1] :
//             (A == 0 && B == 1 && C == 0) ? Q[2] :
//             (A == 0 && B == 1 && C == 1) ? Q[3] :
//             (A == 1 && B == 0 && C == 0) ? Q[4] :
//             (A == 1 && B == 0 && C == 1) ? Q[5] :
//             (A == 1 && B == 1 && C == 0) ? Q[6] :
//             (A == 1 && B == 1 && C == 1) ? Q[7] : 1'bx;

// The following code uses case statement and is more readable
// always @(*) begin
//     case ({A, B, C})
//         3'b000: Z = Q[0];
//         3'b001: Z = Q[1];
//         3'b010: Z = Q[2];
//         3'b011: Z = Q[3];
//         3'b100: Z = Q[4];
//         3'b101: Z = Q[5];
//         3'b110: Z = Q[6];
//         3'b111: Z = Q[7];
//         default: Z = 1'bx;
//     endcase
// end

endmodule