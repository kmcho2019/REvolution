module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Shared comparison and subtraction logic
    function [8:0] div_step;
        input [7:0] remainder;
        input bit_in;
        input [7:0] divisor;
        reg [8:0] dividend_ext;
        begin
            dividend_ext = {remainder, bit_in};
            div_step = (dividend_ext >= {1'b0, divisor}) ? 
                       (dividend_ext - {1'b0, divisor}) : 
                       dividend_ext;
        end
    endfunction

    // Pipeline of remainders
    wire [7:0] rem [0:15];
    wire [8:0] step [0:15];
    
    // Initialize first step
    assign step[0] = {1'b0, A[15]};
    assign rem[0] = step[0][7:0];
    assign result[15] = (step[0] >= {1'b0, B});
    
    // Generate remaining steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            assign step[i] = div_step(rem[i-1], A[15-i], B);
            assign rem[i] = step[i][7:0];
            assign result[15-i] = (step[i] >= {1'b0, B});
        end
    endgenerate

    // Final remainder output (only need 8 bits, zero-extended)
    assign odd = {8'b0, rem[15]};

endmodule