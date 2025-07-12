module Counter(
    input clk,
    input reset,
    input enable,
    output [9:0] count
);

reg [9:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 10'd0;
    end else if (enable) begin
        if (current_count == 10'd999) begin
            current_count <= 10'd0;
        end else begin
            current_count <= current_count + 1;
        end
    end
end

assign count = current_count;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

wire enable;

// Enable the counter to always increment
assign enable = 1'b1;

Counter counter_instance(
   .clk(clk),
   .reset(reset),
   .enable(enable),
   .count(q)
);

endmodule