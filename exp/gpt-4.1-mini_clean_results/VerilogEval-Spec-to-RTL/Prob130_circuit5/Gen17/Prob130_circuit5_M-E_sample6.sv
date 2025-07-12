module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define a function that returns q based on inputs and c
    function [3:0] lookup_q;
        input [3:0] c_in;
        input [3:0] a_in, b_in, d_in, e_in;
        reg [3:0] lut [0:15];
        begin
            lut[ 0] = b_in;  // c=0
            lut[ 1] = e_in;  // c=1
            lut[ 2] = a_in;  // c=2
            lut[ 3] = d_in;  // c=3
            lut[ 4] = 4'hF;  // c=4
            lut[ 5] = 4'hF;  // c=5
            lut[ 6] = 4'hF;  // c=6
            lut[ 7] = 4'hF;  // c=7
            lut[ 8] = 4'hF;  // c=8
            lut[ 9] = 4'hF;  // c=9
            lut[10] = 4'hF;  // c=10
            lut[11] = 4'hF;  // c=11
            lut[12] = 4'hF;  // c=12
            lut[13] = 4'hF;  // c=13
            lut[14] = 4'hF;  // c=14
            lut[15] = 4'hF;  // c=15
            lookup_q = lut[c_in];
        end
    endfunction

    always @(*) begin
        q = lookup_q(c, a, b, d, e);
    end

endmodule