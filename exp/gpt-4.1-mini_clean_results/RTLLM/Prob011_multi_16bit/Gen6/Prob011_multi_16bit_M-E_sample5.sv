module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   bit_pos;       // Counts from 0 to 16 (for 16 bits plus done state)
    reg         done_r;
    reg [15:0]  multiplicand;  // Will be shifted right each cycle
    reg [15:0]  multiplier;    // Fixed multiplier, not shifted
    reg [31:0]  product_acc;   // Accumulates partial sums

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_pos      <= 5'd0;
            done_r       <= 1'b0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product_acc  <= 32'd0;
        end else begin
            if (start && bit_pos == 5'd0) begin
                // Load inputs and reset product and done
                multiplicand <= ain;
                multiplier   <= bin;
                product_acc  <= 32'd0;
                done_r       <= 1'b0;
                bit_pos      <= 5'd1;
            end else if (bit_pos > 0 && bit_pos <= 16) begin
                // Check LSB of multiplicand to decide addition
                if (multiplicand[0]) begin
                    // Add multiplier shifted by current bit position -1
                    product_acc <= product_acc + ({16'd0, multiplier} << (bit_pos - 1));
                end
                // Shift multiplicand right by one bit
                multiplicand <= multiplicand >> 1;

                // Increment bit position or finish
                if (bit_pos == 16) begin
                    done_r  <= 1'b1;
                    bit_pos <= 5'd17; // done state
                end else begin
                    bit_pos <= bit_pos + 5'd1;
                end
            end else if (bit_pos == 5'd17) begin
                // Wait until start is deasserted to reset done flag
                if (!start) begin
                    done_r  <= 1'b0;
                    bit_pos <= 5'd0;
                end
            end else begin
                // Idle state, clear registers if not starting
                if (!start) begin
                    done_r       <= 1'b0;
                    bit_pos      <= 5'd0;
                    multiplicand <= 16'd0;
                    multiplier   <= 16'd0;
                    product_acc  <= 32'd0;
                end
            end
        end
    end

    assign yout = product_acc;
    assign done = done_r;

endmodule