module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Define the desired output values for out_sop
    reg [3:0] sop_values = 4'b0010 | 4'b0111 | 4'b1111;
    
    // Define the desired output values for out_pos
    reg [3:0] pos_values = ~(4'b0000 | 4'b0001 | 4'b0100 | 4'b0101 | 4'b0110 | 4'b1001 | 4'b1010 | 4'b1101 | 4'b1110);
    
    // Combine the inputs into a single 4-bit signal
    reg [3:0] inputs;
    assign inputs = {a, b, c, d};
    
    // Use a case statement to implement the logic equation for out_sop
    always @(*) begin
        case (inputs)
            4'b0010, 4'b0111, 4'b1111: out_sop = 1'b1;
            default: out_sop = 1'b0;
        endcase
    end
    
    // Use a case statement to implement the logic equation for out_pos
    always @(*) begin
        case (inputs)
            4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1101, 4'b1110: out_pos = 1'b0;
            default: out_pos = 1'b1;
        endcase
    end

endmodule