module TopModule(
    input [3:0] x,
    output reg f
);

always @(x) begin
    if ((x == 4'b0011) || (x == 4'b1000) || (x == 4'b1001) || (x == 4'b1100) || (x == 4'b1101) || (x == 4'b1111)) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule