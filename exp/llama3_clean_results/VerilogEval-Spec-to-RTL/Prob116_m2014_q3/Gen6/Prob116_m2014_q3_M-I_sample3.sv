module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    if (x[3] || (x[2] && x[1])) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule