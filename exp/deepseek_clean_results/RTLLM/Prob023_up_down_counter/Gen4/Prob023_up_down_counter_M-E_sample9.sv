module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal signals
reg [15:0] count_inc;
reg [15:0] count_dec;

// Pre-compute both possible next values
always @(posedge clk) begin
    if (reset) begin
        count_inc <= 16'b0;
        count_dec <= 16'b0;
    end
    else begin
        count_inc <= count + 1'b1;
        count_dec <= count - 1'b1;
    end
end

// Select the appropriate next value
always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end
    else begin
        count <= up_down ? count_inc : count_dec;
    end
end

endmodule