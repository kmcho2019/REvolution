module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define a combinational function to perform the lookup
    function [3:0] lut(input [3:0] idx);
        begin
            case (idx)
                4'd0: lut = b;
                4'd1: lut = e;
                4'd2: lut = a;
                4'd3: lut = d;
                default: lut = 4'hF;
            endcase
        end
    endfunction

    always @(*) begin
        q = lut(c);
    end

endmodule