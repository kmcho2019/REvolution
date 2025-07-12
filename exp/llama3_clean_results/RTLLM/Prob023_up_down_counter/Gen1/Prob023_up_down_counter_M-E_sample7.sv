module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            next_count <= count + 1;
        end else begin
            next_count <= count - 1;
        end
        count <= next_count;
    end
end

endmodule