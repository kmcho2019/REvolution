module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Verify parameter is odd and >= 3
initial begin
    if (NUM_DIV % 2 == 0 || NUM_DIV < 3) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

// Calculate required counter width
localparam CNT_WIDTH = $clog2(NUM_DIV);
reg [CNT_WIDTH-1:0] cnt_p, cnt_n;
reg [CNT_WIDTH-1:0] cnt_p_gray, cnt_n_gray;

// Phase-shifted clock enables
reg clk_en_p, clk_en_n;

// Gray code conversion functions
function [CNT_WIDTH-1:0] bin2gray;
    input [CNT_WIDTH-1:0] bin;
    bin2gray = bin ^ (bin >> 1);
endfunction

function [CNT_WIDTH-1:0] gray2bin;
    input [CNT_WIDTH-1:0] gray;
    integer i;
    begin
        gray2bin[CNT_WIDTH-1] = gray[CNT_WIDTH-1];
        for (i = CNT_WIDTH-2; i >= 0; i = i - 1)
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
    end
endfunction

// Positive edge counter (0° phase)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_p <= 0;
        cnt_p_gray <= 0;
        clk_en_p <= 0;
    end else begin
        if (cnt_p == NUM_DIV-1) begin
            cnt_p <= 0;
            clk_en_p <= 1;
        end else begin
            cnt_p <= cnt_p + 1;
            clk_en_p <= (cnt_p == (NUM_DIV-1)/2);
        end
        cnt_p_gray <= bin2gray(cnt_p);
    end
end

// Negative edge counter (180° phase)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_n <= 0;
        cnt_n_gray <= 0;
        clk_en_n <= 0;
    end else begin
        if (cnt_n == NUM_DIV-1) begin
            cnt_n <= 0;
            clk_en_n <= 1;
        end else begin
            cnt_n <= cnt_n + 1;
            clk_en_n <= (cnt_n == (NUM_DIV-1)/2);
        end
        cnt_n_gray <= bin2gray(cnt_n);
    end
end

// Synchronize and combine clock enables
reg clk_en_p_sync, clk_en_n_sync;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_en_p_sync <= 0;
        clk_en_n_sync <= 0;
    end else begin
        clk_en_p_sync <= clk_en_p;
        clk_en_n_sync <= clk_en_n;
    end
end

// Generate final clock output
reg clk_div_p, clk_div_n;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p <= 0;
    end else if (clk_en_p_sync) begin
        clk_div_p <= ~clk_div_p;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_n <= 0;
    end else if (clk_en_n_sync) begin
        clk_div_n <= ~clk_div_n;
    end
end

// Combine both phase clocks
assign clk_div = clk_div_p ^ clk_div_n;

endmodule