module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [11:0] one_hot_cnt; // One-hot encoded counter representing count 0..11

// Combinational decoder: find the index of the '1' bit in one_hot_cnt
// Since only one bit is set at a time, output is position of that bit
// Using a priority encoder approach to map one_hot pattern to binary count

wire [3:0] decoded_count;
assign decoded_count =
    (one_hot_cnt[0]  ? 4'd0  :
    one_hot_cnt[1]  ? 4'd1  :
    one_hot_cnt[2]  ? 4'd2  :
    one_hot_cnt[3]  ? 4'd3  :
    one_hot_cnt[4]  ? 4'd4  :
    one_hot_cnt[5]  ? 4'd5  :
    one_hot_cnt[6]  ? 4'd6  :
    one_hot_cnt[7]  ? 4'd7  :
    one_hot_cnt[8]  ? 4'd8  :
    one_hot_cnt[9]  ? 4'd9  :
    one_hot_cnt[10] ? 4'd10 :
    one_hot_cnt[11] ? 4'd11 : 4'd0);

// Sequential logic: one-hot counting and reset
always @(posedge clk) begin
    if (!rst_n) begin
        one_hot_cnt <= 12'b000000000001; // initialize to count 0
    end else if (valid_count) begin
        // Circular left shift by 1 position
        one_hot_cnt <= {one_hot_cnt[10:0], one_hot_cnt[11]};
    end
    // else hold current one_hot_cnt when valid_count = 0
end

// Output register update synchronously with decoded count
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count)
        out <= decoded_count;
    else
        out <= out; // hold current value
end

endmodule