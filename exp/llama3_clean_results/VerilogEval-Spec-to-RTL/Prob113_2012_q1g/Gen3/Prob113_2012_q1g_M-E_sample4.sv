module TopModule(
    input [3:0] x,
    output reg f
);

always @(x) begin
    f = 1'b0;
    if (x[3:2] == 2'b00) begin
        f = (x[1:0] == 2'b00) || (x[1:0] == 2'b10);
    end else if (x[3:2] == 2'b11) begin
        f = (x[1:0]!= 2'b10);
    end else if (x[3:2] == 2'b10) begin
        f = (x[1:0]!= 2'b11);
    end
end

endmodule