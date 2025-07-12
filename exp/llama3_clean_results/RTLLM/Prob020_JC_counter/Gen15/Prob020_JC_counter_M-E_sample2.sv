// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Define the sub-counter module
module sub_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    input [15:0] in,  // Input value
    output reg [15:0] out  // Output value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out <= 16'd0;
    end else begin
        out <= {~in[0], in[15:1]};
    end
end

endmodule

// Instantiate four sub-counters
wire [15:0] sub_counter1_out;
wire [15:0] sub_counter2_out;
wire [15:0] sub_counter3_out;

sub_counter u_sub_counter1 (
    .clk(clk),
    .rst_n(rst_n),
    .in(Q[15:0]),
    .out(sub_counter1_out)
);

sub_counter u_sub_counter2 (
    .clk(clk),
    .rst_n(rst_n),
    .in(Q[31:16]),
    .out(sub_counter2_out)
);

sub_counter u_sub_counter3 (
    .clk(clk),
    .rst_n(rst_n),
    .in(Q[47:32]),
    .out(sub_counter3_out)
);

// Combine the outputs of the sub-counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q[15:0] <= sub_counter1_out;
        Q[31:16] <= sub_counter2_out;
        Q[47:32] <= sub_counter3_out;
        Q[63:48] <= {~Q[0], Q[15:1]};
    end
end

endmodule