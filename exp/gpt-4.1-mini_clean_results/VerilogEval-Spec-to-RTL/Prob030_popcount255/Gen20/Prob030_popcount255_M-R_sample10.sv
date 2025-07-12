module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);
    // Popcount17 implemented as an internal function used by popcount function
    function automatic [5:0] popcount17_fn(input [16:0] val);
        // Level 1: sum pairs of bits (2-bit results)
        reg [1:0] s0, s1, s2, s3, s4, s5, s6, s7;
        reg leftover;
        reg [2:0] s8, s9, s10, s11;
        reg [3:0] s12, s13;
        reg [4:0] s14;
        begin
            s0 = val[0] + val[1];
            s1 = val[2] + val[3];
            s2 = val[4] + val[5];
            s3 = val[6] + val[7];
            s4 = val[8] + val[9];
            s5 = val[10] + val[11];
            s6 = val[12] + val[13];
            s7 = val[14] + val[15];
            leftover = val[16];
            s8  = s0 + s1;
            s9  = s2 + s3;
            s10 = s4 + s5;
            s11 = s6 + s7;
            s12 = s8 + s9;
            s13 = s10 + s11;
            s14 = s12 + s13;
            popcount17_fn = s14 + leftover;
        end
    endfunction

    // Recursive popcount function with balanced splitting
    function automatic [31:0] popcount_fn(input [254:0] val, input integer width);
        integer half;
        reg [31:0] left_sum;
        reg [31:0] right_sum;
        begin
            if (width <= 17) begin
                // Zero-pad if width < 17
                reg [16:0] tmp;
                integer i;
                for (i = 0; i < 17; i = i +1) begin
                    if (i < width)
                        tmp[i] = val[i];
                    else
                        tmp[i] = 1'b0;
                end
                popcount_fn = popcount17_fn(tmp);
            end else begin
                half = width / 2;
                left_sum = popcount_fn(val[half-1:0], half);
                right_sum = popcount_fn(val[width-1:half], width - half);
                popcount_fn = left_sum + right_sum;
            end
        end
    endfunction

    always @* begin
        // Call popcount function for full 255-bit input; output is 8 bits max (since max sum is 255)
        out = popcount_fn(in, 255)[7:0];
    end
endmodule