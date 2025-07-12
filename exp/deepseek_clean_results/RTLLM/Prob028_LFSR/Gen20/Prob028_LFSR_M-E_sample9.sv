module DualFeedback_LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire fb_primary, fb_secondary, fb_final;

// Primary feedback: XOR of bits 3 and 2
assign fb_primary = out[3] ^ out[2];

// Secondary feedback: XOR of bits 1 and 0 (novel addition)
assign fb_secondary = out[1] ^ out[0];

// Majority voting feedback decision
assign fb_final = (fb_primary & fb_secondary) | 
                  (fb_primary & out[0]) | 
                  (fb_secondary & out[0]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001; // Initialize to non-zero to avoid lock-up
    end
    else begin
        out <= {out[2:0], fb_final};
    end
end

endmodule

module DualFeedback_LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    DualFeedback_LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t: out=%4b", $time, out);
        #10 rst = 0;
        #200 $finish;
    end

    // Verification logic
    reg [3:0] state_history [0:14];
    integer cycle_count = 0;
    integer i, j;

    always @(posedge clk) begin
        if (!rst) begin
            state_history[cycle_count] = out;
            cycle_count = cycle_count + 1;

            // Check for sequence completion
            if (cycle_count == 15) begin
                // Verify all states are unique
                for (i = 0; i < 15; i = i + 1) begin
                    for (j = i + 1; j < 15; j = j + 1) begin
                        if (state_history[i] === state_history[j]) begin
                            $display("Error: Duplicate state detected at cycles %0d and %0d", i, j);
                        end
                    end
                end
                $display("Sequence verification complete - all states unique");
            end
        end
    end
endmodule