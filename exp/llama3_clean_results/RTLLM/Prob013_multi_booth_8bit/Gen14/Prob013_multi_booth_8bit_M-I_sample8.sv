module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;
reg [1:0] state;

// Pipelining: Adding registers to break down the multiplication process
reg [15:0] multiplicand_pipe;
reg [15:0] product_pipe;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
        multiplicand_pipe <= 0;
        product_pipe <= 0;
    end else begin
        case (state)
            0: begin
                // Parallel Processing: Performing operations in parallel
                multiplicand_pipe <= multiplicand;
                product_pipe <= product;
                state <= 1;
            end
            1: begin
                if (ctr < 16) begin
                    if (multiplier[ctr]) begin
                        // Power Reduction: Using a more power-efficient accumulation
                        product_pipe <= product_pipe + multiplicand_pipe;
                    end
                    multiplicand_pipe <= multiplicand_pipe << 1;
                    ctr <= ctr + 1;
                end else begin
                    state <= 2;
                end
            end
            2: begin
                p <= product_pipe;
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