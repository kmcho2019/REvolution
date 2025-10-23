module TopModule(
    input [3:0] x,
    output wire f
);

always @(*) begin
    if (x[3] == 1'b1) begin
        f = 1'b1;
    end else if (x[3] == 1'b0 && x[1] == 1'b1 && x[2] == 1'b1) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule