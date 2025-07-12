module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Dual-edge counter
reg [1:0] state;  // State for FSM
reg clk_div_int;  // Intermediate divided clock
reg clk_div_delayed;  // Delayed version of divided clock for phase shifting
reg clk_div_advanced;  // Advanced version of divided clock for phase shifting

// Dual-edge counter
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// FSM for fractional division control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (cnt == 2) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (cnt == 5) begin
                    state <= 2'b10;
                end
            end
            2'b10: begin
                if (cnt == MUL2_DIV_CLK - 1) begin
                    state <= 2'b00;
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        clk_div_delayed <= clk_div_int;
        clk_div_advanced <= (state == 2'b01) ? 1'b1 : 1'b0;
    end
end

// Clock generation
assign clk_div_int = (state == 2'b01 || state == 2'b10);
assign clk_div = clk_div_int || clk_div_delayed || clk_div_advanced;

endmodule