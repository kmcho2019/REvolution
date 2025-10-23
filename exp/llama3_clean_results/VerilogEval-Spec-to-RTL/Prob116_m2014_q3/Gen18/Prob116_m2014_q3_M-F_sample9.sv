module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    f = 1'b0; // Default value for f
    if (x[3] == 1'b1 && x[2] == 1'b1) begin
        f = 1'b1;
    end else if (x[3] == 1'b1 && x[2] == 1'b0 && x[1] == 1'b1) begin
        f = 1'b1;
    end else if (x[3] == 1'b0 && x[2] == 1'b1 && x[1] == 1'b1 && x[0] == 1'b1) begin
        f = 1'b1;
    end
end

endmodule