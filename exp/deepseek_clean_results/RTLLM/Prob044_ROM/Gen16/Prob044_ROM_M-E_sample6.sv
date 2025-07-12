module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Pattern-generating function instead of explicit memory
    function [15:0] rom_pattern;
        input [7:0] address;
        reg [15:0] a, b, temp;
        integer i;
        begin
            // Fibonacci sequence generator
            a = 16'h0001;
            b = 16'h0001;
            if (address == 0) rom_pattern = a;
            else if (address == 1) rom_pattern = b;
            else begin
                for (i = 2; i <= address; i = i + 1) begin
                    temp = a + b;
                    a = b;
                    b = temp;
                end
                rom_pattern = b;
            end
        end
    endfunction

    // Continuous output of generated pattern
    assign dout = rom_pattern(addr);

endmodule