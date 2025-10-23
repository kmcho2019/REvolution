module freq_divbyfrac(
    input  wire        clk,       // Input clock signal
    input  wire        rst_n,     // Active low reset signal
    output wire        clk_div    // Fractionally divided clock output
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7;  // Counter cycles through 7 clock cycles
localparam DIV_CLOCK_1 = 4;    // First uneven clock period
localparam DIV_CLOCK_2 = 3;    // Second uneven clock period

// Internal signals
reg [2:0]  counter;            // Counter to track clock cycles
reg        clk_int1;           // Intermediate divided clock 1
reg        clk_int2;           // Intermediate divided clock 2
reg        clk_int1_dly;       // Delayed intermediate divided clock 1
reg        clk_int2_adv;       // Advanced intermediate divided clock 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_dly <= 1'b0;
        clk_int2_adv <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            if (clk_int1) begin
                clk_int1 <= 1'b0;
                clk_int2 <= 1'b1;
            end else begin
                clk_int1 <= 1'b1;
                clk_int2 <= 1'b0;
            end
        end else if (counter == DIV_CLOCK_1 - 1) begin
            clk_int1 <= 1'b1;
        end else if (counter == DIV_CLOCK_2 - 1) begin
            clk_int2 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - DIV_CLOCK_1) begin
            clk_int1 <= 1'b0;
        end else if (counter == MUL2_DIV_CLK - DIV_CLOCK_2) begin
            clk_int2 <= 1'b0;
        end
        counter <= counter + 1'b1;
    end
end

// Delay and advance intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1_dly <= 1'b0;
        clk_int2_adv <= 1'b0;
    end else begin
        clk_int1_dly <= clk_int1;
        clk_int2_adv <= clk_int2;
    end
end

// Phase shift and OR intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_int1 | clk_int2 | (clk_int1_dly && !clk_int2) | (clk_int2_adv && !clk_int1);
    end
end

endmodule