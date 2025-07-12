module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Function to reverse bits of 4-bit input
    function [3:0] reverse_bits;
        input [3:0] in;
        integer i;
        begin
            for (i=0; i<4; i=i+1)
                reverse_bits[i] = in[3-i];
        end
    endfunction

    reg [3:0] temp;

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left by 1 and put data in LSB, then reverse bits
            temp = reverse_bits(q);    // reverse current bits
            temp = (temp << 1) | data; // shift left, input at LSB
            q <= reverse_bits(temp);   // reverse again to restore original order
        end
        else if (count_ena) begin
            q <= q - 1;
        end
    end

endmodule