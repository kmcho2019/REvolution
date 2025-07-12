module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Function to perform N-input AND using bit vector input
    function automatic bit andN;
        input integer width;
        input [31:0] inputs;
        integer i;
        begin
            andN = 1'b1;
            for (i = 0; i < width; i = i + 1) begin
                andN = andN & inputs[i];
            end
        end
    endfunction

    // Compute p1y: OR of two 3-input ANDs
    assign p1y = andN(3, {p1c, p1b, p1a}) | andN(3, {p1f, p1e, p1d});

    // Compute p2y: OR of two 2-input ANDs
    assign p2y = andN(2, {p2b, p2a}) | andN(2, {p2d, p2c});

endmodule