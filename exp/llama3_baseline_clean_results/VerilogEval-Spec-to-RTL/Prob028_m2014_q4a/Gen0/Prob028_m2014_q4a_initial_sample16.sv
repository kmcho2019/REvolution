module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal signal to hold the output value
assign q = q_reg; // assign output to internal signal

always @(ena or d) begin
    if (ena) begin
        q_reg <= d; // when ena is high, capture the input value
    end else begin
        // do nothing when ena is low, q_reg will hold its previous value
    end
end

endmodule