module TopModule(
    input clk,
    input d,
    input q
);

reg q_out;

always @(posedge clk) begin
    if (q) begin
        q_out <= d;
    end
end

assign q_out = q_out; // continuous assignment to an output, q_out is assigned to itself to maintain the state

endmodule