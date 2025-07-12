module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    typedef enum {INIT, CALC, DONE} state_t;
    reg [1:0] state;

    // Internal registers
    reg [15:0] multiplicand;  // Sign-extended multiplicand
    reg [7:0] multiplier;     // Multiplier (right shifted)
    reg prev_lsb;             // Previous LSB for Booth encoding
    reg [1:0] iter_ctr;       // 2-bit counter for 4 iterations

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            p <= 16'b0;
            prev_lsb <= 1'b0;
            iter_ctr <= 2'b0;
            state <= INIT;
            rdy <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    state <= CALC;
                end

                CALC: begin
                    // Radix-4 Booth encoding and operation
                    case ({multiplier[1:0], prev_lsb})
                        3'b000, 3'b111: p <= p;                  // +0
                        3'b001, 3'b010: p <= p + multiplicand;    // +1
                        3'b011: p <= p + (multiplicand << 1);     // +2
                        3'b100: p <= p - (multiplicand << 1);     // -2
                        3'b101, 3'b110: p <= p - multiplicand;    // -1
                    endcase

                    // Update registers for next iteration
                    multiplicand <= multiplicand << 2;
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                    
                    // Check completion (4 iterations for 8 bits)
                    if (iter_ctr == 2'b11) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        iter_ctr <= iter_ctr + 1;
                    end
                end

                DONE: begin
                    // Maintain done state until next reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule