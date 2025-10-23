module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] counter; // Counter to cycle through 7 clock cycles
reg [1:0] state; // State machine to generate intermediate clocks
reg clk_int1, clk_int2; // Intermediate clocks
reg delayed_clk, advanced_clk; // Phase-shifted clocks

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        state <= 2'b00; // Reset state machine
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        delayed_clk <= 1'b0;
        advanced_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Counter to cycle through 7 clock cycles
        if (counter == 3'b110) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate intermediate clocks
        case (state)
            2'b00: begin
                if (counter == 3'b100) begin
                    clk_int1 <= 1'b1;
                end else if (counter == 3'b011) begin
                    clk_int1 <= 1'b0;
                end
                if (counter == 3'b101) begin
                    clk_int2 <= 1'b1;
                end else if (counter == 3'b010) begin
                    clk_int2 <= 1'b0;
                end
                state <= 2'b01;
            end
            2'b01: begin
                // Phase-shift intermediate clocks
                delayed_clk <= clk_int1;
                advanced_clk <= clk_int2;
                state <= 2'b10;
            end
            2'b10: begin
                // Logically OR phase-shifted clocks
                clk_div <= delayed_clk | advanced_clk;
                state <= 2'b00;
            end
        endcase
    end
end

endmodule