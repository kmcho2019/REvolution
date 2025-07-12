module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // Function that returns ROM data based on address
    function [15:0] rom_content;
        input [7:0] addr_in;
        begin
            case (addr_in)
                8'd0: rom_content = 16'hA0A0;
                8'd1: rom_content = 16'hB1B1;
                8'd2: rom_content = 16'hC2C2;
                8'd3: rom_content = 16'hD3D3;
                // Add more initialization if needed
                default: rom_content = 16'h0000;
            endcase
        end
    endfunction

    assign dout = rom_content(addr);

endmodule