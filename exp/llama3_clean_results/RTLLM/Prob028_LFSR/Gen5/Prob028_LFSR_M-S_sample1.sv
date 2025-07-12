// Simplified LFSR module
module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

// Calculate feedback based on the XOR of specific bits in the register
assign out = state;

// Sequential logic for shifting and initialization
always @ (posedge clk) begin
    if (rst) begin
        state <= 4'b0000; // Initialize register to zero on reset
    end else begin
        // Shift left and insert feedback
        state <= {state[2:0], ~(state[3] ^ state[2])};
    end
end

endmodule

// Simplified testbench for the LFSR module
module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;

LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generator
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset and stimulus
initial begin
    rst = 1;
    #10;
    rst = 0;
    #100;
    $stop;
end

// Monitor output
initial begin
    $monitor("%g: out = %b", $time, out);
end

endmodule