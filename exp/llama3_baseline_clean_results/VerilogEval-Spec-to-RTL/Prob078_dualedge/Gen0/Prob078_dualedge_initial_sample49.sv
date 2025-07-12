module TopModule(
    input clk,
    input d,
    output q
);

reg q_int; // internal signal to store the output
reg d_prev; // to store previous value of d

always @(posedge clk) begin
    d_prev <= d; // capture d at posedge
end

always @(negedge clk) begin
    q_int <= d_prev; // assign captured d to internal output at negedge
end

assign q = q_int; // output the internal signal

endmodule