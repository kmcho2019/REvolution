module TopModule(
    output zero
);
reg internal_zero;

initial begin
    internal_zero = 1'b0;
end

assign zero = internal_zero;

endmodule