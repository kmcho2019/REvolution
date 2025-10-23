module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Counter to cycle through 7 clock cycles
reg [2:0] cnt;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == 3'b110) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1;
    end
end

// Generate intermediate clocks with uneven periods
reg clk_div_4;
reg clk_div_3;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        if (cnt == 3'b100) begin
            clk_div_4 <= 1'b1;
        end else if (cnt == 3'b101) begin
            clk_div_4 <= 1'b0;
        end
        
        if (cnt == 3'b101) begin
            clk_div_3 <= 1'b1;
        end else if (cnt == 3'b110) begin
            clk_div_3 <= 1'b0;
        end
    end
end

// Phase-shift the intermediate clocks
reg clk_div_4_delayed;
reg clk_div_3_advanced;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_delayed <= 1'b0;
        clk_div_3_advanced <= 1'b0;
    end else begin
        if (cnt == 3'b100) begin
            clk_div_4_delayed <= 1'b0;
        end else if (cnt == 3'b101) begin
            clk_div_4_delayed <= clk_div_4;
        end
        
        if (cnt == 3'b100) begin
            clk_div_3_advanced <= clk_div_3;
        end else if (cnt == 3'b101) begin
            clk_div_3_advanced <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_4_delayed | clk_div_3_advanced;
    end
end

endmodule