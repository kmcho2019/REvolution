module up_down_counter (
    input clk,
    input reset,
    input up_down,
    input enable,          // New enable signal
    output reg [15:0] count
);

// Gray code conversion
wire [15:0] gray_count;
binary_to_gray #(.WIDTH(16)) bg_conv (
    .binary(count),
    .gray(gray_count)
);

// Clock gating logic
wire [3:0] segment_en;
assign segment_en[0] = enable;  // Always enable LSB segment
assign segment_en[1] = enable && (|count[15:4]);  // Enable mid segments when needed
assign segment_en[2] = enable && (|count[15:8]);
assign segment_en[3] = enable && (|count[15:12]);

// Next count calculation (combinational)
wire [15:0] next_count;
assign next_count = reset ? 16'b0 : 
                   (up_down ? count + 1 : count - 1);

// Segmented counting (sequential)
always @(posedge clk) begin
    if (segment_en[0]) count[3:0] <= next_count[3:0];
    if (segment_en[1]) count[7:4] <= next_count[7:4];
    if (segment_en[2]) count[11:8] <= next_count[11:8];
    if (segment_en[3]) count[15:12] <= next_count[15:12];
end

// Gray code converter module
module binary_to_gray #(
    parameter WIDTH = 16
) (
    input [WIDTH-1:0] binary,
    output [WIDTH-1:0] gray
);
    assign gray = binary ^ (binary >> 1);
endmodule

endmodule