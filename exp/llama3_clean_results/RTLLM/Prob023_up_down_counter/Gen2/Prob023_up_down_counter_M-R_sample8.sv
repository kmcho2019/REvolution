module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] next_count;

assign next_count = (up_down) ? (count + 1) : (count - 1);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule