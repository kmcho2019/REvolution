module TopModule(
    input clk,
    input d,
    output reg q
);

// Single always block to handle both positive and negative edge updates
always @(posedge clk or negedge clk) begin
    q <= d;
end

endmodule