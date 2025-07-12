module multi_16bit (
    input           clk,
    input           rst_n,   // active-low synchronous reset
    input           start,
    input  [15:0]   ain,     // multiplicand
    input  [15:0]   bin,     // multiplier
    output [31:0]   yout,    // product
    output          done
);

    reg [4:0]    i;           // bit position counter [0..16]
    reg [15:0]   multiplicand;
    reg [15:0]   multiplier;
    reg [31:0]   product;
    reg          done_r;

    wire        current_bit;
    wire [31:0] shifted_multiplicand;
    wire [31:0] add_result;
    wire        add_enable;

    // Current LSB bit of multiplier used for addition
    assign current_bit = multiplier[0];

    // Shift multiplicand by current bit index for accumulation
    assign shifted_multiplicand = {16'd0, multiplicand} << i;

    // Enable addition only when current bit is 1 and i in 0..15
    assign add_enable = (i < 5'd16) && current_bit;

    // Compute addition result combinationally
    assign add_result = product + (add_enable ? shifted_multiplicand : 32'd0);

    // Sequential logic for control and datapath
    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset all registers
            i             <= 5'd0;
            multiplicand  <= 16'd0;
            multiplier    <= 16'd0;
            product       <= 32'd0;
            done_r        <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load inputs and initialize registers at start
                    multiplicand <= ain;
                    multiplier   <= bin;
                    product      <= 32'd0;
                    done_r      <= 1'b0;
                    i            <= 5'd1;
                end else if (i <= 5'd16) begin
                    // For bits 1..16, accumulate if bit is set
                    product    <= add_result;
                    multiplier <= multiplier >> 1; // shift multiplier right
                    i          <= i + 5'd1;

                    if (i == 5'd16)
                        done_r <= 1'b1; // done after processing 16 bits
                end else begin
                    // Hold values after done
                    product     <= product;
                    multiplier  <= multiplier;
                    multiplicand<= multiplicand;
                    i           <= i;
                    done_r      <= done_r;
                end
            end else begin
                // If start is low, hold values and clear done
                done_r <= 1'b0;
                i      <= 5'd0;
                // Hold inputs and product to allow stable outputs if desired
                multiplicand <= multiplicand;
                multiplier   <= multiplier;
                product      <= product;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule