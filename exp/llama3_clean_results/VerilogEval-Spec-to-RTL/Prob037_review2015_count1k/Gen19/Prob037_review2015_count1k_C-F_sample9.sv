module Counter(
    input clk,
    input reset,
    output [9:0] count
);

reg [9:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 10'd0;
    end else if (current_count == 10'd999) begin
        current_count <= 10'd0;
    end else begin
        current_count <= current_count + 10'd1;
    end
end

assign count = current_count;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

Counter counter_instance(
  .clk(clk),
  .reset(reset),
  .count(q)
);

endmodule