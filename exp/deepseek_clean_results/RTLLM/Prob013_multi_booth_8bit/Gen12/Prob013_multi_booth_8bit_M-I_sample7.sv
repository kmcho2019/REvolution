module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // States for the multiplier
    typedef enum {CALC, DONE} state_t;
    reg state;

    // Internal registers (reduced to 9 bits for sign extension)
    reg [8:0] multiplicand;
    reg [8:0] multiplier;
    reg prev_lsb;
    reg [1:0] iter_ctr;  // 2-bit counter sufficient for 0-4 counts

    // Clock gating signals
    wire calc_active = (state == CALC);
    wire clk_gated = calc_active ? clk : 1'b0;

    // Booth operation (direct arithmetic implementation)
    wire [1:0] booth_sel = {multiplier[1:0], prev_lsb};
    wire [15:0] booth_result = 
        (booth_sel == 3'b000 || booth_sel == 3'b111) ? 16'b0 :
        (booth_sel == 3'b001 || booth_sel == 3'b010) ? {{7{multiplicand[8]}}, multiplicand} :
        (booth_sel == 3'b101 || booth_sel == 3'b110) ? -{{7{multiplicand[8]}}, multiplicand} :
        (booth_sel == 3'b011) ? {{6{multiplicand[8]}}, multiplicand, 1'b0} :
        /* 3'b100 */ -{{6{multiplicand[8]}}, multiplicand, 1'b0};

    // Pipeline register for booth result
    reg [15:0] booth_result_reg;

    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign extension (9 bits)
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 2'b0;
            state <= CALC;
            rdy <= 1'b0;
            booth_result_reg <= 16'b0;
        end else begin
            // Stage 1: Compute Booth operation
            booth_result_reg <= booth_result;

            // Stage 2: Accumulate result
            p <= p + booth_result_reg;

            // Update registers for next iteration
            multiplicand <= multiplicand << 2;
            prev_lsb <= multiplier[1];
            multiplier <= multiplier >> 2;  // Regular shift (sign already extended)

            // Check completion (4 iterations for 8 bits)
            if (iter_ctr == 2'd3) begin
                state <= DONE;
                rdy <= 1'b1;
            end else begin
                iter_ctr <= iter_ctr + 1;
            end
        end
    end

    // Maintain DONE state until reset
    always @(posedge clk) begin
        if (reset) begin
            state <= CALC;
            rdy <= 1'b0;
        end else if (state == DONE) begin
            rdy <= 1'b1;
        end
    end

endmodule