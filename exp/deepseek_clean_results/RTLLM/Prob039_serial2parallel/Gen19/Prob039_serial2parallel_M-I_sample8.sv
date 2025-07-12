module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] buffer;
    reg [2:0] bit_count_gray;
    reg collecting;
    reg valid_pulse;

    // Gray code conversion functions
    function [2:0] bin2gray(input [2:0] b);
        bin2gray = {b[2], b[2:1] ^ b[1:0]};
    endfunction

    function [2:0] gray2bin(input [2:0] g);
        gray2bin = {g[2], g[2] ^ g[1], g[2] ^ g[1] ^ g[0]};
    endfunction

    wire [2:0] bit_count = gray2bin(bit_count_gray);
    wire buffer_en = din_valid & (collecting | (bit_count != 3'd0));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            bit_count_gray <= 3'b0;
            dout_valid <= 1'b0;
            collecting <= 1'b1;
            valid_pulse <= 1'b0;
        end
        else begin
            // Clock-gated buffer update
            if (buffer_en) begin
                buffer[7-bit_count] <= din_serial;
            end

            // Gray counter update
            if (din_valid) begin
                if (collecting) begin
                    bit_count_gray <= bin2gray(gray2bin(bit_count_gray) + 1'b1);
                    collecting <= (bit_count != 3'd6);
                end
                else begin
                    bit_count_gray <= 3'b0;
                    collecting <= 1'b1;
                end
            end

            // Output and valid generation
            if (din_valid && !collecting && bit_count == 3'd7) begin
                dout_parallel <= buffer;
                valid_pulse <= 1'b1;
            end

            // Two-cycle valid pulse
            dout_valid <= valid_pulse;
            if (valid_pulse) begin
                valid_pulse <= 1'b0;
            end
        end
    end

endmodule