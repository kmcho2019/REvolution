module TopModule(
    input  in1,
    input  in2,
    output reg out
);

always @(*) begin
    if (in1 == 1'b1 && in2 == 1'b0) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule