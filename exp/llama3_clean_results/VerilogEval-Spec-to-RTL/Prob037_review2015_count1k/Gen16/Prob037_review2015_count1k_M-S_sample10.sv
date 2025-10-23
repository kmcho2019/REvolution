module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

parameter WIDTH = 10;
parameter MAX_VALUE = 10'd999;

reg [WIDTH-1:0] current_count;

always @(posedge clk) begin
    current_count <= reset? 'd0 : (current_count == MAX_VALUE)? 'd0 : current_count + 1'd1;
end

assign q = current_count;

endmodule