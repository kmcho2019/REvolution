module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] state;  // State machine (0: 4 cycles, 1: 3 cycles)
reg clk_div_int;  // Intermediate divided clock
reg clk_div_delayed;  // Delayed intermediate divided clock

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_delayed <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (cnt == 4'b1000) begin
                    state <= 2'b01;
                    cnt <= 3'b000;
                end else begin
                    cnt <= cnt + 1'b1;
                end
                clk_div_int <= (cnt == 4'b1000)? 1'b1 : 1'b0;
            end
            2'b01: begin
                if (cnt == 4'b0111) begin
                    state <= 2'b00;
                    cnt <= 3'b000;
                end else begin
                    cnt <= cnt + 1'b1;
                end
                clk_div_int <= (cnt == 4'b0111)? 1'b1 : 1'b0;
            end
        endcase
        clk_div_delayed <= clk_div_int;
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = clk_div_int || clk_div_delayed;

endmodule