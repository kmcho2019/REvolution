module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal reg to hold the output value
assign q = q_reg; // continuous assignment to output

always @(ena or d) begin
    if (ena) begin
        q_reg <= d; // update output when ena is high
    end else begin
        // do nothing, q_reg holds its value when ena is low
    end
end

endmodule