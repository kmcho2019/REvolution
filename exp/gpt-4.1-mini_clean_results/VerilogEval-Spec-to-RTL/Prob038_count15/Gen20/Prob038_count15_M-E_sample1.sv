module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] gray_count;

// Increment Gray code by toggling bit 0 or bit corresponding to rightmost zero in gray_count
// But simpler here is to generate next Gray count by binary count + 1 converted to Gray
wire [3:0] binary_next;
wire [3:0] gray_next;

assign binary_next = gray_to_binary(gray_count) + 4'd1; // increment binary
assign gray_next = binary_to_gray(binary_next);

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'b0000;
        q <= 4'b0000;
    end else begin
        gray_count <= gray_next;
        q <= binary_next;  // output binary count for q
    end
end

// Function to convert Gray code to binary
function [3:0] gray_to_binary;
    input [3:0] gray;
    begin
        gray_to_binary[3] = gray[3];
        gray_to_binary[2] = gray[3] ^ gray[2];
        gray_to_binary[1] = gray_to_binary[2] ^ gray[1];
        gray_to_binary[0] = gray_to_binary[1] ^ gray[0];
    end
endfunction

// Function to convert binary to Gray code
function [3:0] binary_to_gray;
    input [3:0] binary;
    begin
        binary_to_gray[3] = binary[3];
        binary_to_gray[2] = binary[3] ^ binary[2];
        binary_to_gray[1] = binary[2] ^ binary[1];
        binary_to_gray[0] = binary[1] ^ binary[0];
    end
endfunction

endmodule