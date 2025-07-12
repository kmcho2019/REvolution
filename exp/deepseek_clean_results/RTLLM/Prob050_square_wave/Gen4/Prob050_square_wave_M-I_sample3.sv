module square_wave #(
    parameter COUNTER_WIDTH = 8
) (
    input clk,
    input [COUNTER_WIDTH-1:0] freq,
    output reg wave_out
);

    reg [COUNTER_WIDTH-1:0] count;
    reg [COUNTER_WIDTH-1:0] freq_reg;
    reg comp_result, comp_result_reg;
    wire count_enable = (freq != 0);  // Clock gating control

    // Gray code counter conversion function
    function [COUNTER_WIDTH-1:0] binary_to_gray;
        input [COUNTER_WIDTH-1:0] binary;
        binary_to_gray = binary ^ (binary >> 1);
    endfunction

    // Pipeline stage 1: Register frequency input and perform comparison
    always @(posedge clk) begin
        freq_reg <= freq;
        comp_result <= (binary_to_gray(count) == freq_reg);
    end

    // Pipeline stage 2: Register comparison result and update outputs
    always @(posedge clk) begin
        comp_result_reg <= comp_result;
        
        if (count_enable) begin
            if (comp_result_reg) begin
                wave_out <= ~wave_out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule