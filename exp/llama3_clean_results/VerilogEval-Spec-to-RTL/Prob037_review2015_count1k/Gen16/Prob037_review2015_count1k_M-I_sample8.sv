module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] current_count;
reg [9:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 10'd0;
    end else begin
        current_count <= next_count;
    end
end

always @(*) begin
    if (current_count == 10'd999) begin
        next_count = 10'd0;
    end else begin
        next_count = current_count + 10'd1;
    end
end

assign q = current_count;

endmodule