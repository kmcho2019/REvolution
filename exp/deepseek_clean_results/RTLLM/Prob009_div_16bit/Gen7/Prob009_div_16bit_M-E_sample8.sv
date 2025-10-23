module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [15:0] divisor_ext = {8'b0, B};
    wire [31:0] dividend_ext = {16'b0, A};
    
    // Parallel prefix computation wires
    wire [15:0] partial_remainder [0:15];
    wire [15:0] quotient_bits;
    wire [15:0] carry_propagate [0:15];
    
    // Initial condition
    assign partial_remainder[0] = dividend_ext[31:16];
    assign carry_propagate[0] = 16'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_stage
            // Conditional subtraction block
            wire [15:0] next_remainder = partial_remainder[i] - divisor_ext;
            wire borrow = next_remainder[15]; // Sign bit indicates negative
            
            // Quotient bit determination
            assign quotient_bits[i] = ~borrow;
            
            // Remainder selection
            wire [15:0] selected_remainder = borrow ? 
                {partial_remainder[i][14:0], dividend_ext[15-i]} : 
                {next_remainder[14:0], dividend_ext[15-i]};
                
            // Carry propagation network
            if (i < 15) begin
                assign partial_remainder[i+1] = selected_remainder;
                assign carry_propagate[i+1] = {carry_propagate[i][14:0], borrow};
            end
        end
    endgenerate
    
    // Final outputs
    assign result = quotient_bits;
    assign odd = partial_remainder[15];
    
endmodule