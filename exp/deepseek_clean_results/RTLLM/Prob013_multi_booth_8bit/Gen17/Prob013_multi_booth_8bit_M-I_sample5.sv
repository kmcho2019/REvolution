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

    // Internal registers (optimized sizes)
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [8:0] multiplier;    // 8-bit + sign
    reg prev_lsb;
    reg [1:0] iter_ctr;      // 2-bit counter for 4 iterations
    
    // Pipeline registers
    reg [15:0] booth_result;
    reg [15:0] p_next;

    // Clock gating signals
    wire calc_clk_en = (state == CALC);
    wire calc_clk = clk & calc_clk_en;

    // Booth encoding function (simplified)
    function [15:0] booth_op;
        input [8:0] A;
        input [2:0] sel;  // {current bits, prev_lsb}
        begin
            case (sel[1:0])
                2'b00: booth_op = (sel[2]) ? -{A, 7'b0} : 16'b0;
                2'b01: booth_op = {A, 7'b0};
                2'b10: booth_op = -{A, 7'b0};
                2'b11: booth_op = {A, 7'b0} << 1;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            booth_result <= 16'b0;
            p_next <= 16'b0;
            iter_ctr <= 2'b0;
            state <= CALC;
            rdy <= 1'b0;
        end else if (calc_clk_en) begin
            // Pipeline stage 1: Booth operation
            booth_result <= booth_op(multiplicand, {multiplier[1:0], prev_lsb});
            
            // Pipeline stage 2: Accumulation (registered)
            p <= p + booth_result;
            
            // Update registers for next iteration
            multiplicand <= multiplicand << 2;
            prev_lsb <= multiplier[1];
            multiplier <= multiplier >> 2;  // Logical shift sufficient after init
            
            // Check completion (4 iterations for 8 bits)
            if (iter_ctr == 2'd3) begin
                state <= DONE;
                rdy <= 1'b1;
            end else begin
                iter_ctr <= iter_ctr + 1;
            end
        end
    end

endmodule