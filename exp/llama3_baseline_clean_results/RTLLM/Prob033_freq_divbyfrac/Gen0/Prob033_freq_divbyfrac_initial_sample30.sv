module freq_divbyfrac (
    input  clk,
    input  rst_n,
    output clk_div
);

// Counter to keep track of the current clock cycle
reg [2:0] cnt;
reg [2:0] nxt_cnt;

// Signals to generate the divided clocks
reg div_clk_4;
reg div_clk_3;
reg div_clk_4_dly;  // Delayed version of div_clk_4
reg div_clk_3_adv;  // Advanced version of div_clk_3

// D flip-flops to delay and advance the divided clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        div_clk_4_dly <= 1'b0;
        div_clk_3_adv <= 1'b0;
    end else begin
        cnt <= nxt_cnt;
        div_clk_4_dly <= div_clk_4;
        div_clk_3_adv <= div_clk_3;
    end
end

// Combinational logic to generate the next counter value and divided clocks
always @(*) begin
    nxt_cnt = cnt + 1'b1;
    
    if (nxt_cnt == 3'b100) begin  // Cycle 7
        nxt_cnt = 3'b000;
    end
    
    // Generate divided clocks based on the counter value
    case (cnt)
        3'b000, 3'b001, 3'b002, 3'b003: begin  // 4 clock cycles
            div_clk_4 = 1'b1;
            div_clk_3 = 1'b0;
        end
        3'b004, 3'b005, 3'b006: begin  // 3 clock cycles
            div_clk_4 = 1'b0;
            div_clk_3 = 1'b1;
        end
        default: begin
            div_clk_4 = 1'b0;
            div_clk_3 = 1'b0;
        end
    endcase
    
    // Generate the final divided clock output by OR-ing the phase-shifted clocks
    clk_div = div_clk_4_dly | div_clk_3_adv;
end

endmodule