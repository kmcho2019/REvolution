module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal register to store the latch value
assign q = q_reg; // assign the internal register to the output

always @(*) // continuous assignment
begin
    if (ena) // check if enable signal is high
    begin
        q_reg <= d; // update the internal register with input 'd'
    end
    else
    begin
        // do nothing, retain the previous value of q_reg
    end
end

endmodule