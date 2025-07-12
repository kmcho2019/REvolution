module TopModule(
    input  [2:0] a,
    output [15:0] q
);

    // Base constant value from first output (a=0)
    localparam [15:0] BASE = 16'h1232;

    // Define masks derived from analysis of outputs differences, mapped by 'a'
    wire [15:0] mask;
    assign mask = (a == 3'd1) ? 16'haeba :
                  (a == 3'd2) ? 16'h1516 :
                  (a == 3'd3) ? 16'h478c :
                  (a == 3'd4) ? 16'h0f54 :
                  (a == 3'd5) ? 16'h469c :
                  (a == 3'd6) ? 16'hc214 :
                  (a == 3'd7) ? 16'h3d0b :
                  16'h0000;

    // Function to rotate left by 'shift' bits
    function [15:0] rol;
        input [15:0] data;
        input [3:0] shift;
        begin
            rol = (data << shift) | (data >> (16-shift));
        end
    endfunction

    // Calculate q by rotating BASE left by 'a' bits, then XOR with mask
    assign q = rol(BASE, a) ^ mask;

endmodule