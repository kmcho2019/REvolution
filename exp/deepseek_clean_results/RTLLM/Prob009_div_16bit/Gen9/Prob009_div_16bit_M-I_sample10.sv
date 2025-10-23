module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Shared comparison and subtraction logic
    function [8:0] div_step;
        input [8:0] dividend_part;
        input [7:0] divisor;
        begin
            if (dividend_part >= {1'b0, divisor}) begin
                div_step = dividend_part - divisor;
            end else begin
                div_step = dividend_part;
            end
        end
    endfunction

    // Pipeline registers for intermediate results
    wire [8:0] stage [0:15];
    wire [7:0] rem [0:15];
    
    // Initialize first stage
    assign stage[0] = {1'b0, A[15]};
    assign {result[15], rem[0]} = div_step(stage[0], B);
    
    // Process remaining stages with shared logic
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : DIV_STAGES
            assign stage[i] = {rem[i-1], A[15-i]};
            assign {result[15-i], rem[i]} = div_step(stage[i], B);
        end
    endgenerate
    
    // Final remainder output
    assign odd = {8'b0, rem[15]};

endmodule