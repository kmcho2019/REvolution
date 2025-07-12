module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg;  // internal register to hold the value of q
assign q = q_reg;  // assign the value of q_reg to output q

always @(*)  // always block is sensitive to all inputs
begin
    if (ena)  // if ena is high, capture the value of d
        q_reg = d;
    // else, q_reg retains its previous value
end

endmodule