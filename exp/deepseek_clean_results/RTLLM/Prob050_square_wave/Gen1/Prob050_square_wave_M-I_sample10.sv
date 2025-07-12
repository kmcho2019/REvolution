module square_wave #(
    parameter COUNTER_WIDTH = 8
)(
    input clk,
    input en,           // Enable signal for power gating
    input [COUNTER_WIDTH-1:0] freq,
    output reg wave_out
);

    // Gray code counter for reduced switching
    reg [COUNTER_WIDTH-1:0] count = 0;
    reg [COUNTER_WIDTH-1:0] count_gray = 0;
    reg [COUNTER_WIDTH-1:0] freq_reg = 0;
    reg comp_result = 0;

    // Gray code conversion functions
    function [COUNTER_WIDTH-1:0] bin2gray;
        input [COUNTER_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    function [COUNTER_WIDTH-1:0] gray2bin;
        input [COUNTER_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[COUNTER_WIDTH-1] = gray[COUNTER_WIDTH-1];
            for (i = COINTER_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Pipeline stage 1: Register frequency and convert count
    always @(posedge clk) begin
        if (en) begin
            freq_reg <= freq;
            count_gray <= bin2gray(count);
        end
    end

    // Pipeline stage 2: Comparison
    always @(posedge clk) begin
        if (en) begin
            comp_result <= (gray2bin(count_gray) == (freq_reg - 1));
        end
    end

    // Pipeline stage 3: Toggle and counter update
    always @(posedge clk) begin
        if (en) begin
            if (comp_result) begin
                wave_out <= ~wave_out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end else begin
            // Reset when disabled
            wave_out <= 0;
            count <= 0;
        end
    end

endmodule