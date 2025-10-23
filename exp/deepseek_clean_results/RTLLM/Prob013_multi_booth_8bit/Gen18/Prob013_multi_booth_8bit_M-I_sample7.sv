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

    // Internal registers (optimized widths)
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [8:0] multiplier;    // 8-bit + sign
    reg prev_lsb;
    reg [1:0] iter_ctr;      // 2-bit counter (counts 0-4)

    // Clock gating signals
    wire calc_active = (state == CALC);
    wire gated_clk = clk & (reset | calc_active);

    // Booth encoding (direct arithmetic implementation)
    wire [1:0] booth_sel = {multiplier[1:0], prev_lsb};
    wire [15:0] booth_out = 
        (booth_sel == 2'b01 || booth_sel == 2'b10) ? {{7{multiplicand[8]}}, multiplicand} :
        (booth_sel == 2'b11) ? -{{7{multiplicand[8]}}, multiplicand} :
        (booth_sel == 2'b00) ? 16'b0 :
        (booth_sel == 2'b10) ? {{6{multiplicand[8]}}, multiplicand, 1'b0} :
        -{{6{multiplicand[8]}}, multiplicand, 1'b0};

    // Pipeline registers
    reg [15:0] booth_stage;
    reg [15:0] acc_stage;

    always @(posedge gated_clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 2'b0;
            state <= CALC;
            rdy <= 1'b0;
            booth_stage <= 16'b0;
            acc_stage <= 16'b0;
        end else if (calc_active) begin
            // Pipeline stage 1: Booth encoding
            booth_stage <= booth_out;

            // Pipeline stage 2: Accumulation
            acc_stage <= p + booth_stage;

            // Update registers for next iteration
            multiplicand <= multiplicand << 2;
            prev_lsb <= multiplier[1];
            multiplier <= {multiplier[8], multiplier[8:2]};  // Simplified shift

            // Update product register
            p <= acc_stage;

            // Check completion (4 iterations for 8 bits)
            if (iter_ctr == 2'd3 || multiplier == 9'b0) begin
                state <= DONE;
                rdy <= 1'b1;
            end else begin
                iter_ctr <= iter_ctr + 1;
            end
        end
    end

endmodule