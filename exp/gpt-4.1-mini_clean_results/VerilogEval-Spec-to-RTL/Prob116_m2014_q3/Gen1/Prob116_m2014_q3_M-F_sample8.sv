module TopModule (
    input [3:0] x,
    output reg f
);

always @(*) begin
    // Map inputs to row and column:
    // row = {x[3], x[0]}
    // col = {x[1], x[2]}
    // case selector = {row, col} = {x[3], x[0], x[1], x[2]}
    case ({x[3], x[0], x[1], x[2]})
        // row=00 (x[3]=0, x[0]=0)
        4'b0000: f = 1'b0; // col=00, K-map cell = d, choose 0
        4'b0001: f = 1'b0; // col=01, K-map cell = 0
        4'b0011: f = 1'b1; // col=11, K-map cell = d, choose 1
        4'b0010: f = 1'b0; // col=10, K-map cell = d, choose 0

        // row=01 (x[3]=0, x[0]=1)
        4'b0100: f = 1'b0; // col=00, K-map cell = 0
        4'b0101: f = 1'b0; // col=01, K-map cell = d, choose 0
        4'b0111: f = 1'b1; // col=11, K-map cell = 1
        4'b0110: f = 1'b0; // col=10, K-map cell = 0

        // row=11 (x[3]=1, x[0]=1)
        4'b1100: f = 1'b1; // col=00, K-map cell = 1
        4'b1101: f = 1'b1; // col=01, K-map cell = 1
        4'b1111: f = 1'b0; // col=11, K-map cell = d, choose 0
        4'b1110: f = 1'b0; // col=10, K-map cell = d, choose 0

        // row=10 (x[3]=1, x[0]=0)
        4'b1000: f = 1'b1; // col=00, K-map cell = 1
        4'b1001: f = 1'b1; // col=01, K-map cell = 1
        4'b1011: f = 1'b0; // col=11, K-map cell = d, choose 0
        4'b1010: f = 1'b0; // col=10, K-map cell = 0

        default: f = 1'b0;
    endcase
end

endmodule