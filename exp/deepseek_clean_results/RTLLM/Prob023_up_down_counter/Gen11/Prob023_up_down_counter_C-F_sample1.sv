module up_down_counter (
    input clk,
    input reset,
    input up_down,
    input enable,          // Added enable signal
    input use_gray,        // Gray code output option
    output reg [15:0] count
);

// Internal signals
reg [15:0] next_count;
wire [15:0] binary_count;
wire [15:0] gray_count;

// Carry lookahead logic
wire [3:0] carry_prop = {count[15:12], count[11:8], count[7:4], count[3:0]};
wire [3:0] carry_gen = carry_prop & {4{up_down}};
wire [3:0] carry = {carry_gen[3] & carry_gen[2] & carry_gen[1],
                   carry_gen[2] & carry_gen[1],
                   carry_gen[1],
                   1'b1};

// Clock gating logic
wire count_active = |count[15:4]; // Check if upper bits are non-zero

always @(*) begin
    if (up_down) begin
        next_count = count + {15'b0, (enable & (count_active | carry[0]))};
    end else begin
        next_count = count - {15'b0, (enable & (count_active | !carry[0]))};
    end
end

// Gray code conversion
assign gray_count = binary_count ^ {1'b0, binary_count[15:1]};

// Output selection
assign binary_count = (use_gray) ? gray_count : count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (enable) begin
        count <= next_count;
    end
end

endmodule