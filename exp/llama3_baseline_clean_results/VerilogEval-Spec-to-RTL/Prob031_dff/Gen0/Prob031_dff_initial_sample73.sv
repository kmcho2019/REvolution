module TopModule(
    input       clk,
    input       d,
    input       q
);

reg q_reg;

initial begin
    q_reg = q; // initialize q_reg with input q
end

always_ff @(posedge clk) begin
    q_reg <= d; // store 'd' on the positive edge of the clock
end

assign q = q_reg; // assign the stored value to output 'q'

endmodule