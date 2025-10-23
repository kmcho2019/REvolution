module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Function to perform balanced reduction for AND, OR, XOR
    // using 2-input gates, handling non-power-of-two input width.
    function automatic [0:0] reduce_and;
        input [99:0] data;
        integer width, i;
        reg [99:0] stage_in;
        reg [99:0] stage_out;
        integer stage_width;
        begin
            stage_in = data;
            width = 100;
            while (width > 1) begin
                stage_width = (width + 1) >> 1; // ceil(width/2)
                for (i = 0; i < stage_width; i = i +1) begin
                    if ((2*i+1) < width)
                        stage_out[i] = stage_in[2*i] & stage_in[2*i+1];
                    else
                        stage_out[i] = stage_in[2*i];
                end
                stage_in = stage_out;
                width = stage_width;
            end
            reduce_and = stage_in[0];
        end
    endfunction

    function automatic [0:0] reduce_or;
        input [99:0] data;
        integer width, i;
        reg [99:0] stage_in;
        reg [99:0] stage_out;
        integer stage_width;
        begin
            stage_in = data;
            width = 100;
            while (width > 1) begin
                stage_width = (width + 1) >> 1; // ceil(width/2)
                for (i = 0; i < stage_width; i = i +1) begin
                    if ((2*i+1) < width)
                        stage_out[i] = stage_in[2*i] | stage_in[2*i+1];
                    else
                        stage_out[i] = stage_in[2*i];
                end
                stage_in = stage_out;
                width = stage_width;
            end
            reduce_or = stage_in[0];
        end
    endfunction

    function automatic [0:0] reduce_xor;
        input [99:0] data;
        integer width, i;
        reg [99:0] stage_in;
        reg [99:0] stage_out;
        integer stage_width;
        begin
            stage_in = data;
            width = 100;
            while (width > 1) begin
                stage_width = (width + 1) >> 1; // ceil(width/2)
                for (i = 0; i < stage_width; i = i +1) begin
                    if ((2*i+1) < width)
                        stage_out[i] = stage_in[2*i] ^ stage_in[2*i+1];
                    else
                        stage_out[i] = stage_in[2*i];
                end
                stage_in = stage_out;
                width = stage_width;
            end
            reduce_xor = stage_in[0];
        end
    endfunction

    assign out_and = reduce_and(in);
    assign out_or  = reduce_or(in);
    assign out_xor = reduce_xor(in);

endmodule