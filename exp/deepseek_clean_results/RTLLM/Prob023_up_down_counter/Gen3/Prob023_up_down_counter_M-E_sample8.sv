module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion registers
reg [15:0] gray_count;
wire [15:0] next_count;

// Clock gating control
wire count_en = reset | (up_down ? (count != 16'hFFFF) : (count != 0));
wire gated_clk = clk & count_en;

// Unified add/subtract logic
assign next_count = reset ? 16'b0 : 
                   (up_down ? count + 1 : count - 1);

// Parallel prefix adder implementation
always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;
        gray_count <= 16'b0;
    end
    else begin
        count <= next_count;
        // Convert to gray code for output
        gray_count <= next_count ^ (next_count >> 1);
    end
end

// Optional: Output either binary or gray code
// assign count = gray_count; // Uncomment for gray code output

endmodule