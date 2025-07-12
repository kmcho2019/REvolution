module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    reg [2:0] temp_bitwise;
    reg temp_logical;
    reg [5:0] temp_not;

    always @(a, b) begin
        temp_bitwise = 0;
        temp_logical = 0;
        temp_not = 0;
        
        // Perform bitwise-OR operation
        for (int i = 0; i < 3; i++) begin
            temp_bitwise[i] = a[i] | b[i];
        end
        
        // Evaluate logical-OR condition
        for (int i = 0; i < 3; i++) begin
            if (a[i] || b[i]) begin
                temp_logical = 1;
                break;
            end
        end
        
        // Invert input vectors
        for (int i = 0; i < 3; i++) begin
            temp_not[i + 3] = ~b[i]; // Invert b and store in upper half
            temp_not[i] = ~a[i]; // Invert a and store in lower half
        end
    end

    assign out_or_bitwise = temp_bitwise;
    assign out_or_logical = temp_logical;
    assign out_not = temp_not;
endmodule