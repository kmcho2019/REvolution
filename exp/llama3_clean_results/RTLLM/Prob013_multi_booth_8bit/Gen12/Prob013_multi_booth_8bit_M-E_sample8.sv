module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Radix-4 Booth multiplier for the most significant 4 bits
reg [15:0] multiplicand_ms;
reg [15:0] multiplier_ms;
reg [3:0] ctr_ms;
reg [15:0] product_ms;

// Radix-4 Booth multiplier for the least significant 4 bits
reg [15:0] multiplicand_ls;
reg [15:0] multiplier_ls;
reg [3:0] ctr_ls;
reg [15:0] product_ls;

// Parallel adder tree
reg [15:0] sum;

// Control unit
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        // Reset the registers and set the initial state
        multiplicand_ms <= 0;
        multiplier_ms <= 0;
        ctr_ms <= 0;
        product_ms <= 0;
        multiplicand_ls <= 0;
        multiplier_ls <= 0;
        ctr_ls <= 0;
        product_ls <= 0;
        sum <= 0;
        state <= 0;
        rdy <= 0;
    end else begin
        case (state)
            0: begin
                // Initialize the Radix-4 Booth multipliers
                multiplicand_ms <= { {4{b[7]}}, b[7:4] };
                multiplier_ms <= { {4{a[7]}}, a[7:4] };
                multiplicand_ls <= { {4{b[3]}}, b[3:0] };
                multiplier_ls <= { {4{a[3]}}, a[3:0] };
                state <= 1;
            end
            1: begin
                // Perform the multiplication process
                if (ctr_ms < 4) begin
                    // Radix-4 Booth multiplier for the most significant 4 bits
                    if (multiplier_ms[ctr_ms] == 1) begin
                        product_ms <= product_ms + multiplicand_ms;
                    end
                    multiplicand_ms <= multiplicand_ms << 1;
                    ctr_ms <= ctr_ms + 1;
                end
                if (ctr_ls < 4) begin
                    // Radix-4 Booth multiplier for the least significant 4 bits
                    if (multiplier_ls[ctr_ls] == 1) begin
                        product_ls <= product_ls + multiplicand_ls;
                    end
                    multiplicand_ls <= multiplicand_ls << 1;
                    ctr_ls <= ctr_ls + 1;
                end
                if (ctr_ms == 4 && ctr_ls == 4) begin
                    // Combine the partial products using a parallel adder tree
                    sum <= product_ms + product_ls;
                    state <= 2;
                end
            end
            2: begin
                // Output the product and set the ready signal
                p <= sum;
                rdy <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule