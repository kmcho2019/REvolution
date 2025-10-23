module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extra bit for previous bit
    reg [15:0] product;
    reg [2:0] ctr;         // 0-4 counter (4 Radix-4 steps)
    reg zero_flag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Append 0 for initial previous bit
            product <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            zero_flag <= (a == 8'b0);
        end else if (!rdy && !zero_flag) begin
            case (multiplier[1:0])
                2'b01: product <= product + multiplicand;
                2'b10: product <= product - multiplicand;
                default: ;  // No operation for 00 or 11
            endcase

            // Arithmetic right shift of product and multiplier
            product <= {product[15], product[15:1]};
            multiplier <= {multiplier[8], multiplier[8:1]};

            // Update counter
            ctr <= ctr + 1;

            // Check for completion
            if (ctr == 3'b100) begin
                rdy <= 1'b1;
                p <= product;
            end
        end else if (zero_flag) begin
            p <= 16'b0;
            rdy <= 1'b1;
        end
    end

endmodule