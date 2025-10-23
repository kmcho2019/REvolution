module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// 4-bit sliding window register
reg [3:0] data_window;

// Parallel comparison units
wire match_pos0, match_pos1, match_pos2, match_pos3;
wire any_match;

// Update sliding window
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        data_window <= 4'b0;
    end else begin
        data_window <= {data_window[2:0], data_in};
    end
end

// Parallel pattern matching at all positions
assign match_pos0 = (data_window[3:0] == 4'b1001);  // Full window match
assign match_pos1 = (data_window[2:0] == 3'b100) & (data_in == 1'b1);  // Partial window + new bit
assign match_pos2 = (data_window[1:0] == 2'b10) & ({data_in, data_window[3]} == 2'b01);  // Wrapped match
assign match_pos3 = (data_window[0] == 1'b1) & ({data_in, data_window[3:2]} == 3'b001);  // Wrapped match

// Early termination logic
assign any_match = match_pos0 | match_pos1 | match_pos2 | match_pos3;

// Registered output
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        sequence_detected <= 1'b0;
    end else begin
        sequence_detected <= any_match;
    end
end

endmodule