module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // Function to implement ROM contents as combinational logic
    function [15:0] rom_func;
        input [7:0] addr_in;
        begin
            case (addr_in)
                8'h00: rom_func = 16'hA0A0;
                8'h01: rom_func = 16'hB1B1;
                8'h02: rom_func = 16'hC2C2;
                8'h03: rom_func = 16'hD3D3;
                // Define other addresses here as needed, default zeros
                default: rom_func = 16'h0000;
            endcase
        end
    endfunction

    assign dout = rom_func(addr);

endmodule