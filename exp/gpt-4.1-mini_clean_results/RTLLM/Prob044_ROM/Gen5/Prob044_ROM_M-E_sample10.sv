module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // Function returning ROM data for a given address
    function [15:0] rom_data;
        input [7:0] address;
        begin
            case (address)
                8'd0: rom_data = 16'hA0A0;
                8'd1: rom_data = 16'hB1B1;
                8'd2: rom_data = 16'hC2C2;
                8'd3: rom_data = 16'hD3D3;
                default: rom_data = 16'h0000; // Default for undefined locations
            endcase
        end
    endfunction

    assign dout = rom_data(addr);

endmodule