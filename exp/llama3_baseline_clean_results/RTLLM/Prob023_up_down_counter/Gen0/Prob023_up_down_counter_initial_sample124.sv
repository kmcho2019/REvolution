module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 16'd0;
    end else if (up_down) begin
        current_count <= current_count + 16'd1;
    end else begin
        current_count <= current_count - 16'd1;
    end
end

assign count = current_count;

endmodule