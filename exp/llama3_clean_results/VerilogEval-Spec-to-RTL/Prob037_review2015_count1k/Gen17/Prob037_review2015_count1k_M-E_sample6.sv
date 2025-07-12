module GrayCodeCounter(
    input clk,
    input reset,
    output [9:0] gray_count
);

reg [9:0] current_count;
reg [9:0] gray_code;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 10'd0;
        gray_code <= 10'd0;
    end else begin
        current_count <= (current_count == 10'd999) ? 10'd0 : current_count + 10'd1;
        gray_code <= current_count ^ (current_count >> 1);
    end
end

assign gray_count = gray_code;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

GrayCodeCounter gray_counter_instance(
   .clk(clk),
   .reset(reset),
   .gray_count(q)
);

endmodule