module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters
parameter MUL2_DIV_CLK = 7; // 3.5x division

// Define internal signals
reg [2:0] count; // Counter for total clock cycles
reg [1:0] phase; // Counter for phase of divided clock
reg clk_div_int1; // Intermediate divided clock 1
reg clk_div_int2; // Intermediate divided clock 2
reg clk_div_int1_dly; // Delayed intermediate divided clock 1
reg clk_div_int2_adv; // Advanced intermediate divided clock 2

// Counter logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 3'b000;
        phase <= 2'b00;
    end else if (count == MUL2_DIV_CLK - 1) begin
        count <= 3'b000;
        phase <= phase + 1'b1;
    end else begin
        count <= count + 1'b1;
    end
end

// Generate intermediate divided clocks
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (phase == 2'b00) begin
        if (count == 3'b100) begin // 4 source clock cycles
            clk_div_int1 <= 1'b1;
        end else if (count == 3'b011) begin // 3 source clock cycles
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b0;
        end
    end else if (phase == 2'b01) begin
        if (count == 3'b100) begin // 4 source clock cycles
            clk_div_int2 <= 1'b1;
        end else if (count == 3'b011) begin // 3 source clock cycles
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b0;
        end
    end else if (phase == 2'b10) begin
        if (count == 3'b100) begin // 4 source clock cycles
            clk_div_int1 <= 1'b1;
        end else if (count == 3'b011) begin // 3 source clock cycles
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b0;
        end
    end else if (phase == 2'b11) begin
        if (count == 3'b100) begin // 4 source clock cycles
            clk_div_int2 <= 1'b1;
        end else if (count == 3'b011) begin // 3 source clock cycles
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b0;
        end
    end
end

// Delay and advance intermediate clocks
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        clk_div_int1_dly <= clk_div_int1;
        clk_div_int2_adv <= clk_div_int2;
    end
end

// Generate final divided clock
assign clk_div = clk_div_int1 | clk_div_int2 | (clk_div_int1_dly && ~clk) | (clk_div_int2_adv && clk);

endmodule