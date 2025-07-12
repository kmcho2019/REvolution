module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    // Combine inputs into a single 9-bit case selector
    wire [8:0] case_selector = {A, B, Cin};

    always @(*) begin
        case (case_selector)
            // All possible combinations where sum <= 9
            9'b0000_0000_0: begin Sum = 4'b0000; Cout = 1'b0; end
            9'b0000_0001_0: begin Sum = 4'b0001; Cout = 1'b0; end
            // ... (all other cases where sum <= 9)
            9'b1001_0000_0: begin Sum = 4'b1001; Cout = 1'b0; end
            
            // Cases where sum > 9 needs correction
            9'b0000_1001_1: begin Sum = 4'b0000; Cout = 1'b1; end
            9'b0001_1001_0: begin Sum = 4'b0000; Cout = 1'b1; end
            // ... (all other cases where sum > 9)
            9'b1001_1001_1: begin Sum = 4'b0101; Cout = 1'b1; end
            
            // Default case (should never occur with valid BCD inputs)
            default: begin Sum = 4'b0000; Cout = 1'b0; end
        endcase
    end

    // Note: In a real implementation, all 512 possible cases would be enumerated
    // This simplified version shows the concept structure
    
endmodule