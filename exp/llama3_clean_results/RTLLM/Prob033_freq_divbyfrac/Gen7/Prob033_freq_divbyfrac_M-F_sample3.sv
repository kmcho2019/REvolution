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
reg clk_div_advanced;  // Advanced intermediate divided clock

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (cnt == 3'b100) begin
                    state <= 2'b01;
                    cnt <= 3'b000;
                end else begin
                    cnt <= cnt + 1'b1;
                end
                clk_div_int <= (cnt == 3'b100)? 1'b1 : 1'b0;
            end
            2'b01: begin
                if (cnt == 3'b011) begin
                    state <= 2'b00;
                    cnt <= 3'b000;
                end else begin
                    cnt <= cnt + 1'b1;
                end
                clk_div_int <= (cnt == 3'b011)? 1'b1 : 1'b0;
            end
        endcase
        // Delay and advance the intermediate divided clock
        if (clk_div_int) begin
            clk_div_delayed <= #1 1'b1; // Delay by 1 clock cycle
            clk_div_advanced <= #0 1'b1; // Advance by half a clock cycle, conceptually
        end else begin
            clk_div_delayed <= 1'b0;
            clk_div_advanced <= 1'b0;
        end
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = clk_div_int || clk_div_delayed || clk_div_advanced;

endmodule