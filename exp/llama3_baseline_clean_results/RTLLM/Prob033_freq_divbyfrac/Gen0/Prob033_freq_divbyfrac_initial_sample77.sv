module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter MUL2_DIV_CLK = 7; // multiplier for fractional division
parameter DIV_PHASE_DELAY = 1; // phase delay for half-integer division
parameter DIV_PHASE_ADVANCE = 1; // phase advance for half-integer division

reg [2:0] counter; // counter to track clock cycles
reg [1:0] state; // FSM state to control division process
reg clk_div_int1, clk_div_int2; // intermediate divided clock signals
reg clk_div_int1_delayed, clk_div_int2_advanced; // phase-shifted clock signals

// Define FSM states
parameter IDLE = 2'd0;
parameter COUNT_4 = 2'd1;
parameter COUNT_3 = 2'd2;

// Reset the module
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        state <= IDLE;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (counter == 3'd0) begin
                    state <= COUNT_4;
                end
            end
            COUNT_4: begin
                if (counter == 3'd4) begin
                    state <= COUNT_3;
                    clk_div_int1 <= 1'b1;
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
            COUNT_3: begin
                if (counter == 3'd7) begin
                    state <= IDLE;
                    counter <= 3'd0;
                    clk_div_int2 <= 1'b1;
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

// Phase-shift the intermediate clock signals
always @(posedge clk) begin
    clk_div_int1_delayed <= clk_div_int1;
    clk_div_int2_advanced <= clk_div_int2;
end

// Logically OR the phase-shifted clock signals
assign clk_div = clk_div_int1_delayed | clk_div_int2_advanced;

endmodule