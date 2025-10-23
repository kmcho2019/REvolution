module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [16:0] multiplier_prev; // [16:15] unused, [14:0] multiplier, [0] prev_bit
    reg [2:0] ctr;
    reg [15:0] sum, carry;
    reg active;

    // Clock gating control
    wire clk_gated = clk & active;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier_prev <= {{8{b[7]}}, b, 1'b0};
            sum <= 16'b0;
            carry <= 16'b0;
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            active <= 1'b1;
        end else if (active) begin
            if (ctr < 4) begin
                // Booth encoding stage (pipelined)
                reg [15:0] pp;
                case (multiplier_prev[2:0])
                    3'b000, 3'b111: pp = 16'b0;
                    3'b001, 3'b010: pp = multiplicand;
                    3'b011: pp = multiplicand << 1;
                    3'b100: pp = -(multiplicand << 1);
                    3'b101, 3'b110: pp = -multiplicand;
                endcase

                // Carry-save addition stage
                {carry, sum} <= (sum + carry) + pp;

                // Update registers
                multiplicand <= multiplicand << 2;
                multiplier_prev <= {2'b0, multiplier_prev[15:2]}; // Arithmetic shift right by 2
                ctr <= ctr + 1;

                // Early termination check
                if (multiplier_prev[15:2] == 14'b0 || multiplier_prev[15:2] == 14'h3FFF) begin
                    active <= 1'b0;
                    p <= sum + carry;
                    rdy <= 1'b1;
                end
            end else begin
                // Final addition and completion
                p <= sum + carry;
                rdy <= 1'b1;
                active <= 1'b0;
            end
        end
    end

endmodule