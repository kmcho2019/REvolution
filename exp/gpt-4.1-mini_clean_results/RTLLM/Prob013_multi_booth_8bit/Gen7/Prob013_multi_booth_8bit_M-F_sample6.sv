module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output
    output reg         rdy      // ready signal
);

    reg [4:0] ctr;              // 5-bit counter 0 to 16
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg [15:0] multiplier;           // sign-extended multiplier (treated unsigned for indexing)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};  // sign-extend multiplicand
            multiplier   <= {{8{b[7]}}, b};  // sign-extend multiplier
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If multiplier bit at ctr is 1, add multiplicand to product
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 for next cycle
                multiplicand <= multiplicand << 1;

                // Increment counter
                ctr <= ctr + 5'd1;

                // Ready signal low during operation
                rdy <= 1'b0;
            end else begin
                // Completed multiplication
                rdy <= 1'b1;
            end
        end
    end

endmodule