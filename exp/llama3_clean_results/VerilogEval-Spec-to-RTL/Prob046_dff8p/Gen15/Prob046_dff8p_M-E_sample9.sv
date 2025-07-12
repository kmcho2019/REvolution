// Define a module for a single D flip-flop with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0; // Reset value for a single bit
    end else begin
        q <= d;
    end
end

endmodule

// Define the TopModule that uses a serial-in parallel-out concept
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value as a parameter
parameter RESET_VALUE = 8'h34;

// Generate the reset bits
wire [7:0] reset_bits;
always @(*) begin
    reset_bits = RESET_VALUE;
end

// Instantiate the D flip-flops
DFF u_dff_0(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[0] : d[0]),
    .q(q[0])
);

DFF u_dff_1(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[1] : d[1]),
    .q(q[1])
);

DFF u_dff_2(
    .clk(clk),
    .reset(reset),
    .reset_bits(reset ? reset_bits[2] : d[2]),
    .q(q[2])
);

DFF u_dff_3(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[3] : d[3]),
    .q(q[3])
);

DFF u_dff_4(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[4] : d[4]),
    .q(q[4])
);

DFF u_dff_5(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[5] : d[5]),
    .q(q[5])
);

DFF u_dff_6(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[6] : d[6]),
    .q(q[6])
);

DFF u_dff_7(
    .clk(clk),
    .reset(reset),
    .d(reset ? reset_bits[7] : d[7]),
    .q(q[7])
);

endmodule