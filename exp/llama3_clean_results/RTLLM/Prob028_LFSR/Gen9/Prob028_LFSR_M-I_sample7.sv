// Improved LFSR module with optimized functionality and documentation
module LFSR(
    input  logic clk,        // Clock signal
    input  logic rst,        // Active high reset signal
    output logic [3:0] out   // 4-bit output representing the current state of the LFSR
);

// Initialize the LFSR with a seed value when reset is deasserted
always_ff @ (posedge clk) begin
    if (rst) begin
        out <= 4'b1000; // Initialize with a non-zero seed value for better randomness
    end else begin
        // Calculate the feedback as the inverted XOR of out[3] and out[2]
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

// Optimized testbench for minimal simulation time and effective verification
module tb_LFSR;
logic clk, rst;
logic [3:0] out;

LFSR uut (.clk(clk), .rst(rst), .out(out));

// Efficient clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    #100; // Run simulation for 100 time units
    $finish;
end

// Optional: Add assertions or monitors for out to verify the LFSR's functionality
always @ (posedge clk) begin
    if (!rst) begin
        // Example assertion: Check if out is not stuck at zero after reset
        assert (out != 4'b0) else $error("LFSR output stuck at zero");
    end
end

endmodule