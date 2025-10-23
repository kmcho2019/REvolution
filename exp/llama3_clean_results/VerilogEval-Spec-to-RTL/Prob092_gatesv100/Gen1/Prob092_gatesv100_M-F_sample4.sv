module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] out_both;
    reg [99:0] out_any;
    reg [99:0] out_different;
    integer i;

    always @(in)
    begin
        // Initialize outputs
        out_both = 0;
        out_any = 0;
        out_different = 0;

        // Loop through each bit
        for (i = 0; i < 100; i++)
        begin
            // Calculate out_both
            if (i < 99)
                out_both[i] = in[i] && in[i+1];
            else
                out_both[i] = 0;

            // Calculate out_any
            if (i > 0)
                out_any[i] = in[i] || in[i-1];
            else
                out_any[i] = 0;

            // Calculate out_different
            if (i < 99)
                out_different[i] = in[i]!== in[i+1];
            else
                out_different[i] = in[i]!== in[0];
        end
    end

endmodule