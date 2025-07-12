module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration
    reg [15:0] mem [0:255];

    // Function to initialize memory
    function automatic void init_mem;
        input [15:0] default_value;
        integer i;
        begin
            for (i = 0; i < 256; i = i + 1) begin
                mem[i] = default_value;
            end
            // Set specific values
            mem[0] = 16'hA0A0;
            mem[1] = 16'hB1B1;
            mem[2] = 16'hC2C2;
            mem[3] = 16'hD3D3;
        end
    endfunction

    // Initialize memory
    initial begin
        init_mem(16'h0000); // Default all locations to 0
    end

    // Continuous read operation
    assign dout = mem[addr];

endmodule