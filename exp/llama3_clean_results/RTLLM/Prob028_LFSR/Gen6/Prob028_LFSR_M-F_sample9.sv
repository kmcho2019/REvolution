// Revised LFSR module
module LFSR(
    input  logic clk,      // 1-bit clock signal
    input  logic rst,      // 1-bit reset signal
    output logic [3:0] out  // 4-bit output
);

reg [3:0] state;           // Internal 4-bit state register

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

// Revised testbench for the LFSR module
module LFSR_tb;

logic clk;         // 1-bit clock signal
logic rst;         // 1-bit reset signal
wire [3:0] out;     // 4-bit output

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
    rst = 1'b1;
    #10;
    rst = 1'b0;
    #100;
    $stop;
end

// Monitor output
initial begin
    $monitor("%g: out = %b", $time, out);
end

endmodule