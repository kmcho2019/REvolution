module Counter(
    input clk,
    input reset,
    output [9:0] count
);

parameter WIDTH = 10;
parameter MAX_VALUE = 10'd999;

reg [WIDTH-1:0] current_count;

always @(posedge clk) begin
    if (reset || current_count == MAX_VALUE) begin
        current_count <= 'd0;
    end else begin
        current_count <= current_count + 1'd1;
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