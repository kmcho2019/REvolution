module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    function [15:0] rom_data;
        input [7:0] addr_in;
        begin
            case (addr_in)
                8'h00: rom_data = 16'hA0A0;
                8'h01: rom_data = 16'hB1B1;
                8'h02: rom_data = 16'hC2C2;
                8'h03: rom_data = 16'hD3D3;
                default: rom_data = 16'h0000; // default data for uninitialized addresses
            endcase
        end
    endfunction

    assign dout = rom_data(addr);

endmodule