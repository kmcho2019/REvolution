module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 10'd0;
    end else begin
        current_count <= (current_count == 10'd999)? 10'd0 : current_count + 10'd1;
    end
end

assign q = current_count;

endmodule