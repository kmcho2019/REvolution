module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] mcand;        // Multiplicand (sign extended)
    reg [7:0] mplier;        // Multiplier (right shifted)
    reg [1:0] counter;       // 2-bit counter for 4 iterations
    reg prev_bit;            // Previous bit for Booth encoding
    reg [15:0] partial_prod; // Partial product register
    reg compute_en;          // Computation enable (clock gating)

    // Pre-computed values
    wire [15:0] mcand_x1 = mcand;
    wire [15:0] mcand_x2 = mcand << 1;
    wire [15:0] p_plus_x1 = p + mcand_x1;
    wire [15:0] p_plus_x2 = p + mcand_x2;
    wire [15:0] p_minus_x1 = p - mcand_x1;
    wire [15:0] p_minus_x2 = p - mcand_x2;

    // Clock gating logic
    always @(*) begin
        compute_en = ~reset & ~rdy;
    end

    // Pipeline Stage 1: Booth encoding and arithmetic preparation
    always @(posedge clk) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};
            mplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
            partial_prod <= 16'b0;
        end else if (compute_en) begin
            case ({mplier[1:0], prev_bit})
                3'b000, 3'b111: partial_prod <= p;          // +0
                3'b001, 3'b010: partial_prod <= p_plus_x1;   // +1
                3'b011: partial_prod <= p_plus_x2;           // +2
                3'b100: partial_prod <= p_minus_x2;          // -2
                3'b101, 3'b110: partial_prod <= p_minus_x1;  // -1
            endcase
        end
    end

    // Pipeline Stage 2: Register updates and shifting
    always @(posedge clk) begin
        if (compute_en) begin
            p <= partial_prod;
            mcand <= mcand << 2;         // Shift multiplicand left by 2
            mplier <= mplier >> 2;       // Shift multiplier right by 2
            prev_bit <= mplier[1];        // Save previous bit
            counter <= counter + 1;
            rdy <= (counter == 2'b11);   // Done after 4 iterations
        end
    end

endmodule