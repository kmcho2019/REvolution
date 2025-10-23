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
    reg [8:0] mcand;         // 8-bit + sign
    reg [7:0] mplier;        // Multiplier
    reg prev_bit;            // Previous LSB for Booth encoding
    reg [1:0] iter_ctr;      // 2-bit counter for 4 iterations

    // Pre-computed values (wire for timing optimization)
    wire [15:0] mcand_ext = {{7{mcand[8]}}, mcand};
    wire [15:0] mcand_x1 = mcand_ext;
    wire [15:0] mcand_x2 = mcand_ext << 1;

    // Clock gating control
    wire active_cycle = (state == CALC);

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            mcand <= {a[7], a};
            mplier <= b;
            p <= 16'b0;
            prev_bit <= 1'b0;
            iter_ctr <= 2'b0;
            state <= INIT;
            rdy <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    // Early termination for zero inputs
                    if (a == 8'b0 || b == 8'b0) begin
                        p <= 16'b0;
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        state <= CALC;
                    end
                end

                CALC: begin
                    // Parallel Booth encoding evaluation
                    case ({mplier[1:0], prev_bit})
                        3'b001, 3'b010: p <= p + mcand_x1;  // +1
                        3'b011:         p <= p + mcand_x2;  // +2
                        3'b100:         p <= p - mcand_x2;  // -2
                        3'b101, 3'b110: p <= p - mcand_x1;  // -1
                        default:        ;                   // +0 (000,111)
                    endcase

                    // Update registers
                    mcand <= mcand << 2;
                    mplier <= mplier >> 2;
                    prev_bit <= mplier[1];
                    
                    // Iteration control
                    if (iter_ctr == 2'b11) begin
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