module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Pipeline registers
reg [15:0] count_ff;
reg [15:0] next_count;

// Clock gating control
wire count_enable = ~reset & (up_down | (|count)); // Enable unless reset or counting down to zero

// Kogge-Stone parallel prefix adder structure
wire [15:0] carry_propagate, carry_generate;
wire [15:0] sum;

// Generate propagate and generate terms
assign carry_propagate = up_down ? ~count : count; // For increment: propagate when bit is 1, for decrement: propagate when bit is 0
assign carry_generate = up_down ? count : ~count;  // For increment: generate when bit is 0, for decrement: generate when bit is 1

// First level of carry computation
wire [15:0] carry1;
assign carry1[0] = 1'b1; // Initial carry-in
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : carry_level1
        assign carry1[i] = carry_generate[i-1] | (carry_propagate[i-1] & carry1[i-1]);
    end
endgenerate

// Second level of carry computation (parallel prefix)
wire [15:0] carry2;
assign carry2[0] = carry1[0];
assign carry2[1] = carry1[1];
generate
    for (i = 2; i < 16; i = i + 1) begin : carry_level2
        assign carry2[i] = carry_generate[i-2] | (carry_propagate[i-2] & carry1[i-2]);
    end
endgenerate

// Final sum computation
assign sum = count ^ {carry2[14:0], 1'b1} ^ carry_propagate;

// Clock gated process
always @(posedge clk) begin
    if (reset) begin
        count_ff <= 16'b0;
        next_count <= 16'b0;
    end
    else if (count_enable) begin
        count_ff <= next_count;
        next_count <= sum;
    end
end

assign count = count_ff;

endmodule