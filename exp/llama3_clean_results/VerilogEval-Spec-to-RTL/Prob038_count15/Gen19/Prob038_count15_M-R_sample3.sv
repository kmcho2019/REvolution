module Counter(
    input clk,
    input reset,
    output reg [3:0] q
);

// The counter logic remains the same as in the original design.
always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= q + 1'd1;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

// Instantiate the Counter module within TopModule.
Counter counter_instance(
    .clk(clk),
    .reset(reset),
    .q(q)
);

endmodule