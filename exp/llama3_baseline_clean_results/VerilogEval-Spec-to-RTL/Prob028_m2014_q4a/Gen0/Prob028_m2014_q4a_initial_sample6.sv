module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // Internal register to hold the output value
assign q = q_reg; // Continuous assignment to output

always @(d or ena) // Sensitivity list includes 'd' and 'ena'
begin
    if (ena) // When 'ena' is high, capture the input 'd'
    begin
        q_reg <= d;
    end
    // When 'ena' is low, do nothing and the current value of 'q' is held
end

endmodule