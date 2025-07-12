module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early termination for zero divisor
    wire zero_divisor = (B == 8'b0);
    
    // Intermediate remainder wires
    wire [7:0] rem [0:15];
    
    // Generate division steps
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_steps
            if (i == 0) begin
                // First step
                wire [8:0] current_step = {1'b0, A[15]};
                assign rem[0] = zero_divisor ? 8'b0 : 
                              ((current_step >= {1'b0, B}) ? (current_step - B) : current_step[7:0]);
                assign result[15] = zero_divisor ? 1'b0 : (current_step >= {1'b0, B});
            end
            else begin
                // Subsequent steps
                wire [8:0] current_step = {rem[i-1], A[15-i]};
                assign rem[i] = zero_divisor ? 8'b0 : 
                               ((current_step >= {1'b0, B}) ? (current_step - B) : current_step[7:0]);
                assign result[15-i] = zero_divisor ? 1'b0 : (current_step >= {1'b0, B});
            end
        end
    endgenerate
    
    // Output assignments
    assign odd = zero_divisor ? A[7:0] : rem[15];

endmodule