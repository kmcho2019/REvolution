module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a function to implement the ROM lookup combinationally
    function [15:0] rom_lookup;
        input [2:0] addr;
        begin
            case (addr)
                3'd0: rom_lookup = 16'h1232;
                3'd1: rom_lookup = 16'haee0;
                3'd2: rom_lookup = 16'h27d4;
                3'd3: rom_lookup = 16'h5a0e;
                3'd4: rom_lookup = 16'h2066;
                3'd5: rom_lookup = 16'h64ce;
                3'd6: rom_lookup = 16'hc526;
                3'd7: rom_lookup = 16'h2f19;
                default: rom_lookup = 16'h0000;
            endcase
        end
    endfunction

    // Assign output using the function
    assign q = rom_lookup(a);

endmodule