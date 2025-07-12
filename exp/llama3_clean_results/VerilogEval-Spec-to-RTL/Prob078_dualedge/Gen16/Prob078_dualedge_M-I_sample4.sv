module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signal for the dual-edge flip-flop
reg q_int;  

// Dual-edge triggered flip-flop using a single register
always @(posedge clk or negedge clk) begin
    if (clk == 1'b1) begin
        q_int <= d;
    end else if (clk == 1'b0) begin
        q_int <= d;
    end
end

// Directly assign the output
assign q = q_int;

endmodule