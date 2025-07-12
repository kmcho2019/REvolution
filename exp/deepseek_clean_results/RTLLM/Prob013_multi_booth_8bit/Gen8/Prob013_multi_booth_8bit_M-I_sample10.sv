module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // States for the multiplier
    typedef enum {INIT, CALC, DONE} state_t;
    reg [1:0] state;

    // Internal registers (optimized widths)
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [8:0] multiplier;    // 8-bit + sign
    reg prev_lsb;
    reg [1:0] iter_ctr;      // 2-bit counter sufficient for 5 iterations (0-4)
    
    // Pipeline registers
    reg [15:0] booth_result;
    reg [15:0] accum_in;

    // Clock gating signals
    wire calc_clk_en = (state == CALC);
    wire calc_clk = clk & calc_clk_en;

    // Simplified Booth encoding
    always @(*) begin
        case ({multiplier[1:0], prev_lsb})
            3'b000, 3'b111: booth_result = 16'b0;
            3'b001, 3'b010: booth_result = {{7{multiplicand[8]}}, multiplicand};
            3'b101, 3'b110: booth_result = -{{7{multiplicand[8]}}, multiplicand};
            3'b011: booth_result = {{6{multiplicand[8]}}, multiplicand, 1'b0};
            3'b100: booth_result = -{{6{multiplicand[8]}}, multiplicand, 1'b0};
            default: booth_result = 16'b0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 2'b0;
            state <= INIT;
            rdy <= 1'b0;
            accum_in <= 16'b0;
        end else begin
            case (state)
                INIT: begin
                    state <= CALC;
                    rdy <= 1'b0;
                    accum_in <= 16'b0;
                end

                CALC: begin
                    // Pipeline stage 1: Booth operation (combinational)
                    // Pipeline stage 2: Accumulation
                    p <= accum_in + booth_result;
                    accum_in <= accum_in + booth_result;

                    // Update registers for next iteration
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[1];
                    multiplier <= {multiplier[8], multiplier[8:2]};  // Simpler shift

                    // Check completion (4 iterations for 8 bits)
                    if (iter_ctr == 2'd3) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        iter_ctr <= iter_ctr + 1;
                    end
                end

                DONE: begin
                    // Maintain state until next reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule