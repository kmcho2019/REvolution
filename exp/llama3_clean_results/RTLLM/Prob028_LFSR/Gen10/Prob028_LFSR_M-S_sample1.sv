// Simplified LFSR module
module LFSR(
    input  logic clk,        // Clock signal
    input  logic rst,        // Active high reset signal
    output logic [3:0] out   // 4-bit output representing the current state of the LFSR
);

logic [3:0] reg_out;

always_ff @ (posedge clk) begin
    if (rst) begin
        reg_out <= 4'b1000; // Initialize with a non-zero seed value
    end else begin
        reg_out <= {reg_out[2:0], ~(reg_out[3] ^ reg_out[2])};
    end
end

assign out = reg_out;

endmodule

// Simplified testbench
module tb_LFSR;
logic clk, rst;
logic [3:0] out;

LFSR uut (.clk(clk), .rst(rst), .out(out));

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    #100; // Run simulation for 100 time units
    $finish;
end

endmodule