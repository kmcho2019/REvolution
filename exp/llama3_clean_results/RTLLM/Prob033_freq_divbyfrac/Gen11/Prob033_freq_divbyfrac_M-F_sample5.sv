module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] state;  // State machine to generate divided clock signal
reg prev_clk;   // Previous clock value for edge detection

// Sequential logic for counter and state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        state <= 2'b00;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        prev_clk <= clk;
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // State machine to generate divided clock signal
        case (state)
            2'b00: begin
                if (cnt == 0) begin
                    state <= 2'b01;
                    if (clk && !prev_clk) begin
                        clk_div <= 1'b1;
                    end
                end
            end
            2'b01: begin
                if (cnt == 3) begin
                    state <= 2'b10;
                    if (!clk && prev_clk) begin
                        clk_div <= 1'b0;
                    end
                end
            end
            2'b10: begin
                if (cnt == 4) begin
                    state <= 2'b11;
                    if (clk && !prev_clk) begin
                        clk_div <= 1'b1;
                    end
                end
            end
            2'b11: begin
                if (cnt == MUL2_DIV_CLK - 1) begin
                    state <= 2'b00;
                    if (!clk && prev_clk) begin
                        clk_div <= 1'b0;
                    end
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule