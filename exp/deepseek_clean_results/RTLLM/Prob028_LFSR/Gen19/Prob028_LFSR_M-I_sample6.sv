module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

parameter SEED = 4'b0001;  // Initial seed value

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= SEED;
    end
    else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

module LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;
    integer cycle_count = 0;
    parameter MAX_CYCLES = 20;

    LFSR dut (.clk(clk), .rst(rst), .out(out));

    // Clock generation
    always #5 clk = ~clk;

    // Cycle counter
    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
    end

    initial begin
        $monitor("Cycle %0d: out = %4b", cycle_count, out);
        
        // Reset sequence
        #10 rst = 0;
        $display("Reset released at time %0t", $time);
        
        // Expected sequence verification
        fork
            begin
                #10;  // Wait for first valid output
                if (out !== 4'b0001) $error("Initial state mismatch");
                #10 if (out !== 4'b0010) $error("State 2 mismatch");
                #10 if (out !== 4'b0101) $error("State 3 mismatch");
                #10 if (out !== 4'b1011) $error("State 4 mismatch");
                // Continue for full sequence verification...
            end
            
            // Simulation timeout
            begin
                #(MAX_CYCLES*10);
                $display("Simulation completed after %0d cycles", MAX_CYCLES);
                $finish;
            end
        join
    end
endmodule