module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    reg [15:0] mem [0:255];

    // Initialize the ROM contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Additional initializations can be added here
    end

    // Function to read memory contents based on address
    function [15:0] read_mem;
        input [7:0] address;
        begin
            read_mem = mem[address];
        end
    endfunction

    // Assign output using the function call for combinational read
    assign dout = read_mem(addr);

endmodule