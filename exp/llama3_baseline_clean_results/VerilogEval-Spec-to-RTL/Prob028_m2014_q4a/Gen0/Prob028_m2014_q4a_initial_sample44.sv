module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal signal to hold the output value
assign q = q_reg; // assign the internal signal to the output port

always @(d or ena) // sensitivity list includes both d and ena
begin
    if (ena) // when enable is high, capture the input data
    begin
        q_reg <= d;
    end
    // when enable is low, do nothing and hold the previous value
end

endmodule