module multi_16bit (
    input          clk,
    input          rst_n,    // asynchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count: 0..17
    reg          done_r;
    reg [15:0]   areg;       // multiplicand
    reg [15:0]   breg;       // multiplier, shifted right each cycle
    reg [31:0]   product;    // accumulation register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i       <= 5'd0;
            done_r  <= 1'b0;
            areg    <= 16'd0;
            breg    <= 16'd0;
            product <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Initialize registers at start
                    areg    <= ain;
                    breg    <= bin;
                    product <= 32'd0;
                    i       <= 5'd1;
                    done_r  <= 1'b0;
                end else if (i >= 5'd1 && i <= 5'd16) begin
                    // Check LSB of multiplier register breg; if 1 add multiplicand shifted by (i-1)
                    if (breg[0])
                        product <= product + ( {16'd0, areg} << (i - 1) );
                    else
                        product <= product;
                    // Shift multiplier right by 1
                    breg <= breg >> 1;
                    i <= i + 5'd1;

                    // Assert done flag when i == 16
                    done_r <= (i == 5'd16) ? 1'b1 : 1'b0;
                end else if (i == 5'd17) begin
                    // Reset done flag and counter after completion
                    done_r <= 1'b0;
                    i <= 5'd0;
                end else begin
                    // Should not occur, reset for safety
                    i <= 5'd0;
                    done_r <= 1'b0;
                end
            end else begin
                // If start not asserted, reset all for idle
                i       <= 5'd0;
                done_r  <= 1'b0;
                areg    <= 16'd0;
                breg    <= 16'd0;
                product <= 32'd0;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule