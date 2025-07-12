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

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;
    reg [2:0] iter_ctr;  // 3-bit counter for 5 iterations (8 bits / 2 bits per iteration)

    // Booth encoding function
    function [15:0] booth_op;
        input [15:0] A;
        input [2:0] sel;  // {current bits, prev_lsb}
        begin
            case (sel)
                3'b000, 3'b111: booth_op = 16'b0;
                3'b001, 3'b010: booth_op = A;
                3'b101, 3'b110: booth_op = -A;
                3'b011: booth_op = A << 1;
                3'b100: booth_op = -(A << 1);
                default: booth_op = 16'b0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 3'b0;
            state <= INIT;
            rdy <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end

                CALC: begin
                    // Perform Booth operation
                    p <= p + booth_op(multiplicand, {multiplier[1:0], prev_lsb});

                    // Update registers for next iteration
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[1];  // Track previous bit for next encoding
                    multiplier <= $signed(multiplier) >>> 2;  // Arithmetic right shift with sign extension

                    // Check completion (5 iterations for 8 bits)
                    if (iter_ctr == 3'd4) begin
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