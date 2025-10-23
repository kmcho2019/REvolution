module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // reg variable to store the output value

always @(d, ena) begin
    if (ena) begin
        q_reg <= d; // assign d to q_reg when ena is high
    end
end

assign q = q_reg; // assign the value of q_reg to output q

endmodule