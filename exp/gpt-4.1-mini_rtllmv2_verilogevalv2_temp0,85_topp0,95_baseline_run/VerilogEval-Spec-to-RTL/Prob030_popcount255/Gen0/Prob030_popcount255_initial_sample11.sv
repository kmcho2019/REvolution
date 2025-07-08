module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

    // Function to count number of 1's in input vector
    function [7:0] popcount;
        input [254:0] data;
        integer i;
        begin
            popcount = 0;
            for (i = 0; i < 255; i = i + 1) begin
                popcount = popcount + data[i];
            end
        end
    endfunction

    assign out = popcount(in);

endmodule