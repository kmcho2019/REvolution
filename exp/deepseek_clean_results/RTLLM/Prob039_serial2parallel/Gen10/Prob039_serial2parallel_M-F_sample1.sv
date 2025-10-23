module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Gray code counter (3-bit) for minimal transitions
    reg [2:0] cnt_gray;
    wire [2:0] next_cnt_gray;
    wire cnt_full = (cnt_gray == 3'b100); // Gray code for 7 (binary 111)
    
    // Binary to Gray code conversion
    function [2:0] bin2gray;
        input [2:0] bin;
        begin
            bin2gray = {bin[2], bin[2:1] ^ bin[1:0]};
        end
    endfunction

    // Counter increment logic
    wire [2:0] cnt_bin = (cnt_gray[2] ^ cnt_gray[1]) ? {1'b1, cnt_gray[1:0]} : 
                        (cnt_gray[1] ^ cnt_gray[0]) ? {2'b10, cnt_gray[0]} : 
                        {3'b111};
    assign next_cnt_gray = (cnt_full) ? 3'b000 : bin2gray(cnt_bin + 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_gray <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Shift register update only when valid
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Gray counter update
                cnt_gray <= next_cnt_gray;
                
                // Generate valid pulse when counter reaches 7
                if (cnt_full) begin
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule