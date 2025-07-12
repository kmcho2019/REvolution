// Define a module for the serial-in parallel-out (SIPO) shift register
module SIPOShiftRegister(
    input clk,
    input reset,
    input serial_data,
    output [7:0] parallel_data
);

reg [7:0] shift_reg;

always_ff @(negedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], serial_data};
    end
end

assign parallel_data = shift_reg;

endmodule

// Define a module for the 8-bit D flip-flops with active high synchronous reset
module DFF8Bit(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// Define a module for the counter
module Counter(
    input clk,
    input reset,
    output [2:0] count
);

reg [2:0] count_reg;

always_ff @(negedge clk) begin
    if (reset) begin
        count_reg <= 3'b0;
    end else begin
        count_reg <= count_reg + 1'b1;
    end
end

assign count = count_reg;

endmodule

// Define the TopModule
module TopModule(
    input clk,
    input reset,
    input d,
    output [7:0] q
);

wire [7:0] si_po_data;
wire [2:0] count;

SIPOShiftRegister u_si_po(
    .clk(clk),
    .reset(reset),
    .serial_data(d),
    .parallel_data(si_po_data)
);

Counter u_counter(
    .clk(clk),
    .reset(reset),
    .count(count)
);

DFF8Bit u_dff(
    .clk(clk),
    .reset((reset) || (count != 3'b111)),
    .d(si_po_data),
    .q(q)
);

endmodule