module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Must be even number (2, 4, 6, ...)

// Gray code counter (width sufficient for NUM_DIV/2)
reg [3:0] gray_cnt;
reg [3:0] bin_cnt; // Binary counter for conversion

// State for output generation
typedef enum {LOW, HIGH} state_t;
state_t state;

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even number");
    end
end

// Binary to Gray code conversion
function [3:0] bin2gray;
    input [3:0] bin;
    begin
        bin2gray = {bin[3], bin[3:1] ^ bin[2:0]};
    end
endfunction

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bin_cnt <= 4'b0;
        gray_cnt <= 4'b0;
        clk_div <= 1'b0;
        state <= LOW;
    end else begin
        // Increment binary counter
        if (bin_cnt == (NUM_DIV/2)-1) begin
            bin_cnt <= 4'b0;
        end else begin
            bin_cnt <= bin_cnt + 1;
        end

        // Update Gray code counter
        gray_cnt <= bin2gray(bin_cnt);

        // State machine for output generation
        case (state)
            LOW: if (bin_cnt == (NUM_DIV/2)-1) begin
                state <= HIGH;
                clk_div <= 1'b1;
            end
            HIGH: if (bin_cnt == (NUM_DIV/2)-1) begin
                state <= LOW;
                clk_div <= 1'b0;
            end
        endcase
    end
end

endmodule