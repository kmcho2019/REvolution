module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define the LUT values as localparams for easy maintenance
    localparam [15:0] LUT [0:7] = {
        16'h2f19, // 7
        16'hc526, // 6
        16'h64ce, // 5
        16'h2066, // 4
        16'h5a0e, // 3
        16'h27d4, // 2
        16'haee0, // 1
        16'h1232  // 0
    };

    // Function to return LUT value indexed by a
    function [15:0] get_q;
        input [2:0] idx;
        begin
            get_q = LUT[idx];
        end
    endfunction

    // Continuous assignment of output using the function
    assign q = get_q(a);

endmodule