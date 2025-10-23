module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplier input
    input      [7:0]   b,       // multiplicand input
    output reg [15:0]  p,       // product output
    output reg         rdy       // ready signal
);

    // State encoding (1-hot)
    reg idle, load, calc;

    // Registers for multiplier, multiplicand, product, and counter
    reg signed [15:0] multiplier;
    reg signed [15:0] multiplicand;
    reg signed [15:0] product;
    reg [4:0]         ctr;

    // Combinational signal: add_enable when multiplier bit ctr is 1
    wire add_enable = multiplier[ctr];

    always @(posedge clk) begin
        if (reset) begin
            // On reset, load inputs sign-extended
            multiplier   <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            product      <= 16'sd0;
            ctr          <= 5'd0;

            idle <= 1'b0;
            load <= 1'b1;   // next cycle go to load state to start calc
            calc <= 1'b0;

            p   <= 16'd0;
            rdy <= 1'b0;
        end else begin
            // State transitions
            if (idle) begin
                // Idle state, wait for reset release
                idle <= 1'b0;
                load <= 1'b1;
                calc <= 1'b0;
                rdy <= 1'b0;
                p   <= 16'd0;
            end else if (load) begin
                // Load inputs (inputs already loaded on reset, just transition)
                idle <= 1'b0;
                load <= 1'b0;
                calc <= 1'b1;
                rdy  <= 1'b0;
            end else if (calc) begin
                if (ctr < 5'd16) begin
                    // Perform Booth multiplication step
                    if (add_enable)
                        product <= product + multiplicand;
                    else
                        product <= product;

                    multiplicand <= multiplicand <<< 1; // shift left arithmetic

                    ctr <= ctr + 1'b1;
                    rdy <= 1'b0;
                end else begin
                    // Multiplication complete
                    calc <= 1'b0;
                    idle <= 1'b1;
                    rdy <= 1'b1;
                    p   <= product;
                end
            end else begin
                // Default fallback: go idle
                idle <= 1'b1;
                load <= 1'b0;
                calc <= 1'b0;
                rdy  <= 1'b0;
                p    <= 16'd0;
            end
        end
    end

endmodule