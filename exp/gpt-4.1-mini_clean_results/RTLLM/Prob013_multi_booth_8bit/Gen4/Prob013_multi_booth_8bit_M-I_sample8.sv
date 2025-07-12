module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // Internal registers:
    // multiplier and multiplicand are sign-extended 16-bit registers
    reg signed [15:0] multiplicand;
    reg signed [15:0] multiplier;

    // Counter counts up to 16
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize multiplicand and multiplier with sign-extended inputs
            multiplicand <= { {8{a[7]}}, a };
            multiplier   <= { {8{b[7]}}, b };
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // At each cycle:
                // If current multiplier LSB is 1, add multiplicand to product
                if (multiplier[0] == 1'b1) begin
                    p <= p + multiplicand[15:0];
                end
                // Shift multiplicand left by 1 (multiplicand * 2)
                multiplicand <= multiplicand <<< 1;
                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >>> 1; // arithmetic shift right
                // Increment counter
                ctr <= ctr + 1'b1;
            end else begin
                // Completed multiplication
                rdy <= 1'b1;
                // Hold outputs stable
                // Optional: Could keep p stable by not changing it here
            end
        end
    end

endmodule