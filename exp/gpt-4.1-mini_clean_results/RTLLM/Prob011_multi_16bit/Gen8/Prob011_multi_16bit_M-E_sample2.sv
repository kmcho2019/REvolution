module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg         done
);

    reg [31:0] acc;      // accumulator for the partial product
    reg [15:0] areg;     // multiplicand register
    reg [15:0] breg;     // multiplier register
    reg [4:0]  i;        // bit counter, counts 0 to 16

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc   <= 32'd0;
            areg  <= 16'd0;
            breg  <= 16'd0;
            i     <= 5'd0;
            yout  <= 32'd0;
            done  <= 1'b0;
        end else begin
            if (start && i == 0) begin
                // Load inputs and clear accumulator and counter on start
                areg  <= ain;
                breg  <= bin;
                acc   <= 32'd0;
                i     <= 5'd0;
                done  <= 1'b0;
                yout  <= 32'd0;
            end else if (i < 16) begin
                // Shift and add
                if (breg[0]) begin
                    // Add multiplicand shifted by i to accumulator
                    // Instead of shifting multiplicand left by i, just add areg to upper half of acc shifted properly
                    // But here simpler to add multiplicand to lower half of acc before shifting
                    acc <= acc + {16'd0, areg};
                end
                // Shift acc and multiplier right by 1 for next bit
                acc <= acc >> 1;
                breg <= breg >> 1;
                i <= i + 5'd1;
            end else if (i == 16) begin
                // Multiplication done, output product and assert done flag
                yout <= acc;
                done <= 1'b1;
                i <= i + 5'd1; // to prevent re-entering this branch
            end else begin
                // Wait for next start signal
                done <= 1'b0;
            end
        end
    end

endmodule