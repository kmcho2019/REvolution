module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // declare q_reg as a reg type to hold the value
assign q = q_reg; // assign q_reg to output q

always @(*) // use always block with (*) to capture any changes
begin
    if (ena) // if enable signal is high
        q_reg <= d; // output q follows input d
    else
        q_reg <= q_reg; // if enable is low, hold previous value
end

endmodule