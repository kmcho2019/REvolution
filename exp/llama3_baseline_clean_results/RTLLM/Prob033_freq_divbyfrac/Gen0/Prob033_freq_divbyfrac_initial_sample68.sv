module freq_divbyfrac (
    input clk, 
    input rst_n, 
    output reg clk_div
);

// Define the constant for the clock division
localparam MUL2_DIV_CLK = 7;

// Define the counter to track the clock cycles
reg [2:0] counter;

// Define the signals for the uneven clock periods
reg clk_div_4;
reg clk_div_3;
reg clk_div_4Delayed;
reg clk_div_3Advanced;

// Define the initial values for the signals
initial begin
    counter = 3'b000;
    clk_div_4 = 1'b0;
    clk_div_3 = 1'b0;
    clk_div_4Delayed = 1'b0;
    clk_div_3Advanced = 1'b0;
    clk_div = 1'b0;
end

// Generate the uneven clock periods
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4Delayed <= 1'b0;
        clk_div_3Advanced <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == 3'b110) begin // 6 clock cycles have passed
            counter <= 3'b000;
            clk_div_4 <= 1'b1;
            clk_div_3 <= 1'b0;
        end else if (counter == 3'b011) begin // 3 clock cycles have passed
            counter <= counter + 1'b1;
            clk_div_4 <= 1'b0;
            clk_div_3 <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            clk_div_4 <= 1'b0;
            clk_div_3 <= 1'b0;
        end

        // Phase shift the intermediate clocks
        if (counter == 3'b001) begin
            clk_div_4Delayed <= 1'b1;
        end else begin
            clk_div_4Delayed <= 1'b0;
        end

        if (counter == 3'b101) begin
            clk_div_3Advanced <= 1'b1;
        end else begin
            clk_div_3Advanced <= 1'b0;
        end
    end
end

// Generate the final fractional divided clock output
assign clk_div = clk_div_4Delayed | clk_div_3Advanced;

endmodule