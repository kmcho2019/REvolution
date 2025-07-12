module multi_booth_8bit (
    input clk,
    input reset,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [15:0] p,
    output reg rdy
);

    reg signed [15:0] multiplicand;  // 16-bit to hold shifted values
    reg signed [8:0] multiplier;     // 9-bit to include LSB and handle sign
    reg prev_lsb;                   // Previous LSB for Booth encoding
    reg [2:0] iter;                 // Iteration counter (0-3 for 8 bits)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= { {8{a[7]}}, a };
            multiplier <= {b, 1'b0};      // Extra bit for initial prev_lsb
            p <= 16'b0;
            iter <= 3'b0;
            rdy <= 1'b0;
            prev_lsb <= 1'b0;
        end else if (!rdy) begin
            // Booth encoding (examine 3 bits: multiplier[1:0] + prev_lsb)
            case ({multiplier[1:0], prev_lsb})
                3'b000, 3'b111: ;  // No operation
                3'b001, 3'b010: p <= p + multiplicand;      // +A
                3'b101, 3'b110: p <= p - multiplicand;      // -A
                3'b011: p <= p + (multiplicand << 1);       // +2A
                3'b100: p <= p - (multiplicand << 1);       // -2A
            endcase

            // Update for next iteration
            multiplicand <= multiplicand << 2;               // Shift left by 2
            multiplier <= multiplier >>> 2;                 // Arithmetic right shift by 2
            prev_lsb <= multiplier[0];                      // Save current LSB
            
            if (iter == 3'd3) begin
                rdy <= 1'b1;    // Done after 4 iterations
            end else begin
                iter <= iter + 1;
            end
        end
    end

endmodule