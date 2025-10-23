module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion
wire [15:0] gray_count;
binary_to_gray bg(.binary(count), .gray(gray_count));

// Clock gating control
wire count_enable = ~reset;  // Disable counting during reset

// Separate increment/decrement paths
wire [15:0] next_count_up = count + 1'b1;
wire [15:0] next_count_down = count - 1'b1;

// Carry-lookahead adder implementation
wire [15:0] next_count = up_down ? next_count_up : next_count_down;

// Gated clock
reg gated_clk;
always @(posedge clk) begin
    gated_clk <= clk & count_enable;
end

// Main counter logic
always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

// Binary to Gray code converter
module binary_to_gray(
    input [15:0] binary,
    output [15:0] gray
);
    assign gray = binary ^ (binary >> 1);
endmodule

endmodule