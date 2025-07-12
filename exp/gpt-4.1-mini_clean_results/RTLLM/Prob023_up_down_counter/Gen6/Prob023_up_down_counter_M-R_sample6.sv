module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

reg [15:0] next_count;

always @(*) begin
    if (reset) begin
        next_count = 16'd0;
    end else if (up_down) begin
        next_count = count + 16'd1;
    end else begin
        next_count = count - 16'd1;
    end
end

always @(posedge clk) begin
    count <= next_count;
end

endmodule