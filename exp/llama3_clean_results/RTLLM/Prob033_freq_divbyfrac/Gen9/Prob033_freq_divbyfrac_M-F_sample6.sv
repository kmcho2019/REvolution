module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_4;  // 4-cycle clock signal
reg clk_3;  // 3-cycle clock signal
reg clk_4_dly;  // Delayed 4-cycle clock signal
reg clk_3_adv;  // Advanced 3-cycle clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate 4-cycle and 3-cycle clock signals
always @(*) begin
    case (cnt)
        3'b000, 3'b001, 3'b002, 3'b003: begin
            clk_4 = 1'b1;  // 4 cycles clock
            clk_3 = 1'b0;
        end
        3'b004, 3'b005, 3'b006: begin
            clk_4 = 1'b0;
            clk_3 = 1'b1;  // 3 cycles clock
        end
        default: begin
            clk_4 = 1'b0;
            clk_3 = 1'b0;
        end
    endcase
end

// Phase-shifting logic
reg prev_clk_4;
reg prev_clk_3;
always @(posedge clk) begin
    prev_clk_4 <= clk_4;
    prev_clk_3 <= clk_3;
end
assign clk_4_dly = (cnt == 3'b001 || cnt == 3'b002 || cnt == 3'b003 || cnt == 3'b004);
assign clk_3_adv = (cnt == 3'b005 || cnt == 3'b006);

// Output logic
assign clk_div = (clk_4 && !prev_clk_4) || (clk_3 && !prev_clk_3) || clk_4_dly || clk_3_adv;

endmodule