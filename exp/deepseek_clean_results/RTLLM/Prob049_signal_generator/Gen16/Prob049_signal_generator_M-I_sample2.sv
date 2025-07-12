module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave_gray
);

reg direction;  // 0 = increment, 1 = decrement
wire [4:0] next_wave_bin;
wire [4:0] wave_bin;

// Binary to Gray conversion
function [4:0] bin2gray;
    input [4:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

// Gray to Binary conversion (for internal arithmetic)
function [4:0] gray2bin;
    input [4:0] gray;
    begin
        gray2bin[4] = gray[4];
        gray2bin[3] = gray2bin[4] ^ gray[3];
        gray2bin[2] = gray2bin[3] ^ gray[2];
        gray2bin[1] = gray2bin[2] ^ gray[1];
        gray2bin[0] = gray2bin[1] ^ gray[0];
    end
endfunction

// Convert current Gray output to binary for arithmetic
assign wave_bin = gray2bin(wave_gray);

// Single arithmetic unit with direction control
assign next_wave_bin = direction ? wave_bin - 1'b1 : wave_bin + 1'b1;

// Overflow/underflow detection built into arithmetic
wire overflow = (next_wave_bin == 5'b11111) & ~direction;
wire underflow = (next_wave_bin == 5'b00000) & direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_gray <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Immediate direction change at boundaries
        if (overflow) begin
            direction <= 1'b1;
            wave_gray <= bin2gray(5'b11111); // Max value
        end else if (underflow) begin
            direction <= 1'b0;
            wave_gray <= bin2gray(5'b00000); // Min value
        end else begin
            wave_gray <= bin2gray(next_wave_bin);
        end
    end
end

endmodule