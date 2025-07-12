module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7;
localparam DIV CLK_CYCLES_1 = 4;
localparam DIV CLK_CYCLES_2 = 3;

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock 1
reg clk_div_int2;  // Intermediate divided clock 2
reg clk_div_int1_dly;  // Delayed version of clk_div_int1
reg clk_div_int2_adv;  // Advanced version of clk_div_int2

// FSM to generate divided clocks
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        case (cnt)
            3'b000: begin
                // Generate divided clock 1 (4 source clock cycles)
                if (cnt == 3'b000) begin
                    clk_div_int1 <= 1'b1;
                    cnt <= cnt + 1;
                end else if (cnt == 3'b100) begin
                    clk_div_int1 <= 1'b0;
                    cnt <= 3'b001;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            3'b001: begin
                // Generate divided clock 2 (3 source clock cycles)
                if (cnt == 3'b001) begin
                    clk_div_int2 <= 1'b1;
                    cnt <= cnt + 1;
                end else if (cnt == 3'b100) begin
                    clk_div_int2 <= 1'b0;
                    cnt <= 3'b000;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            default: begin
                cnt <= cnt + 1;
            end
        endcase
    end
end

// Generate delayed and advanced versions of divided clocks
always @ (posedge clk) begin
    clk_div_int1_dly <= clk_div_int1;
    clk_div_int2_adv <= clk_div_int2;
end

// Generate final divided clock output
assign clk_div = clk_div_int1 | clk_div_int2 | clk_div_int1_dly | clk_div_int2_adv;

endmodule