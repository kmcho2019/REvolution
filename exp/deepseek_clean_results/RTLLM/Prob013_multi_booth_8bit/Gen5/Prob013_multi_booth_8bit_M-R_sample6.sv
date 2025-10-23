module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // States for the multiplier
    typedef enum {IDLE, CALC, DONE} state_t;
    state_t state;

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;
    reg [1:0] iter_ctr;  // Only need 2 bits for 4 iterations

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
            iter_ctr <= 2'b0;
            state <= IDLE;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end

                CALC: begin
                    // Perform Booth operation
                    p <= p + booth_op(multiplicand, {multiplier[1:0], prev_lsb});

                    // Update registers for next iteration
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[0];
                    multiplier <= multiplier >>> 2;  // Arithmetic right shift

                    // Check completion
                    if (iter_ctr == 2'd3) begin
                        state <= DONE;
                    end else begin
                        iter_ctr <= iter_ctr + 1;
                    end
                end

                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE;  // Ready for next operation
                end
            endcase
        end
    end

endmodule