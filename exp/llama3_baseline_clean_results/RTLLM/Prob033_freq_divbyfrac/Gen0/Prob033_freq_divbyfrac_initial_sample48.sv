module freq_divbyfrac (
    input  clk,       // Input clock signal
    input  rst_n,      // Active low reset signal
    output clk_div    // Fractionally divided clock output
);

// Define the multiplier and divisor for 3.5x division
localparam MUL2_DIV_CLK = 7;

// Counter to track clock cycles
reg [2:0] cnt;
reg [2:0] next_cnt;

// Intermediate divided clock signals
reg clk_div_int1;
reg clk_div_int2;
reg next_clk_div_int1;
reg next_clk_div_int2;

// Phase-shifted clock signals
reg clk_div_int1_phase;
reg clk_div_int2_phase;
reg next_clk_div_int1_phase;
reg next_clk_div_int2_phase;

// Final fractional divided clock output
reg next_clk_div;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'd0;
    end else begin
        cnt <= next_cnt;
    end
end

always @(*) begin
    case (cnt)
        3'd0: next_cnt = 3'd1;
        3'd1: next_cnt = 3'd2;
        3'd2: next_cnt = 3'd3;
        3'd3: next_cnt = 3'd4;
        3'd4: next_cnt = 3'd5;
        3'd5: next_cnt = 3'd6;
        3'd6: next_cnt = 3'd0;
        default: next_cnt = 3'd0;
    endcase
end

// Intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        clk_div_int1 <= next_clk_div_int1;
        clk_div_int2 <= next_clk_div_int2;
    end
end

always @(*) begin
    case (cnt)
        3'd0: begin
            next_clk_div_int1 = 1'b1;
            next_clk_div_int2 = 1'b0;
        end
        3'd3: begin
            next_clk_div_int1 = 1'b0;
            next_clk_div_int2 = 1'b1;
        end
        default: begin
            next_clk_div_int1 = 1'b0;
            next_clk_div_int2 = 1'b0;
        end
    endcase
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_phase <= 1'b0;
        clk_div_int2_phase <= 1'b0;
    end else begin
        clk_div_int1_phase <= next_clk_div_int1_phase;
        clk_div_int2_phase <= next_clk_div_int2_phase;
    end
end

always @(*) begin
    next_clk_div_int1_phase = clk_div_int1;
    next_clk_div_int2_phase = clk_div_int2;
    
    // Delay clk_div_int1 by half a clock period
    if (cnt == 3'd1) begin
        next_clk_div_int1_phase = 1'b1;
    end
    
    // Advance clk_div_int2 by half a clock period
    if (cnt == 3'd4) begin
        next_clk_div_int2_phase = 1'b1;
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= next_clk_div;
    end
end

always @(*) begin
    next_clk_div = clk_div_int1_phase | clk_div_int2_phase;
end

endmodule