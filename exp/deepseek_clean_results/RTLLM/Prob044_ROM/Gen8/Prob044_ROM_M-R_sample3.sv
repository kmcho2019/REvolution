module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration: 256 locations of 16 bits each
    reg [15:0] mem [0:255];

    // Initialize only required memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Function to read memory
    function [15:0] read_mem;
        input [7:0] address;
        begin
            read_mem = mem[address];
        end
    endfunction

    // Continuous read operation using function
    assign dout = read_mem(addr);

endmodule