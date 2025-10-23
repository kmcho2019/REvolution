module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Reduced register sizes
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [2:0] multiplier;    // current 2 bits + prev_lsb
    reg [15:0] p_temp;
    reg [1:0] counter;
    reg compute_en;

    // Pre-computed arithmetic paths
    wire [15:0] m_plus = { {7{multiplicand[8]}}, multiplicand };
    wire [15:0] m_2plus = m_plus << 1;
    wire [15:0] m_minus = -m_plus;
    wire [15:0] m_2minus = -m_2plus;

    // Clock gating control
    wire clk_en = ~rdy | reset;
    wire gated_clk = clk & clk_en;

    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {a[7], a};
            multiplier <= {b[1:0], 1'b0};
            p <= 16'b0;
            p_temp <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            compute_en <= 1'b1;
        end else if (compute_en) begin
            // Stage 1: Booth encoding and arithmetic
            case (multiplier)
                3'b000, 3'b111: p_temp <= p;
                3'b001, 3'b010: p_temp <= p + m_plus;
                3'b011:         p_temp <= p + m_2plus;
                3'b100:         p_temp <= p + m_2minus;
                3'b101, 3'b110: p_temp <= p + m_minus;
            endcase

            // Stage 2: Update registers
            p <= p_temp;
            multiplicand <= multiplicand << 2;
            multiplier <= {b[2*counter+3:2*counter+2], multiplier[0]};

            // Completion detection
            if (counter == 2'b11) begin
                rdy <= 1'b1;
                compute_en <= 1'b0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule