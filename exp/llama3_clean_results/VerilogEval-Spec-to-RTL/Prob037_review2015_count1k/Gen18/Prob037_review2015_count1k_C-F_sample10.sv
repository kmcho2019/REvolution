module Counter(
    input clk,
    input reset,
    output [9:0] count
);

parameter WIDTH = 10;
parameter MAX_VALUE = 10'd999;

reg [WIDTH-1:0] current_count;

always @(posedge clk) begin
    current_count <= reset? 'd0 : (current_count == MAX_VALUE)? 'd0 : current_count + 1'd1;
end

assign count = current_count;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

Counter #(.WIDTH(10), .MAX_VALUE(10'd999)) counter_instance(
   .clk(clk),
   .reset(reset),
   .count(q)
);

endmodule