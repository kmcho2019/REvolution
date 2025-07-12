// Define a module for a single D flip-flop with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Define a module for an 8-bit shift register
module ShiftRegister(
    input clk,
    input load,
    input [7:0] data,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(negedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else begin
        shift_reg <= {shift_reg[6:0], 1'b0};
    end
end

assign q = shift_reg;

endmodule

// Define the TopModule using the DFF and ShiftRegister modules
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

wire [7:0] shift_out;
reg [7:0] reset_value;

// Initialize the reset value
initial begin
    reset_value = 8'h34;
end

// Instantiate the ShiftRegister module
ShiftRegister shift_reg(
    .clk(clk),
    .load(reset),
    .data(reset_value),
    .q(shift_out)
);

// Instantiate 8 DFF modules
DFF dff0(
    .clk(clk),
    .reset(reset),
    .d(d[0]),
    .q(q[0])
);

DFF dff1(
    .clk(clk),
    .reset(reset),
    .d(d[1]),
    .q(q[1])
);

DFF dff2(
    .clk(clk),
    .reset(reset),
    .d(d[2]),
    .q(q[2])
);

DFF dff3(
    .clk(clk),
    .reset(reset),
    .d(d[3]),
    .q(q[3])
);

DFF dff4(
    .clk(clk),
    .reset(reset),
    .d(d[4]),
    .q(q[4])
);

DFF dff5(
    .clk(clk),
    .reset(reset),
    .d(d[5]),
    .q(q[5])
);

DFF dff6(
    .clk(clk),
    .reset(reset),
    .d(d[6]),
    .q(q[6])
);

DFF dff7(
    .clk(clk),
    .reset(reset),
    .d(d[7]),
    .q(q[7])
);

endmodule