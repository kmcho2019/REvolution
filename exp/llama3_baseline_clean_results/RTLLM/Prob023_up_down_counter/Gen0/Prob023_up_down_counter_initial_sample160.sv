module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 16'd0;
    end else if (up_down) begin
        counter <= counter + 1;
    end else begin
        counter <= counter - 1;
    end
end

assign count = counter;

endmodule