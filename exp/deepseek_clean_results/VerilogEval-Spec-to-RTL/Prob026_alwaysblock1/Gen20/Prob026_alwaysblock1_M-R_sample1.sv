module TopModule #(
    parameter VERIFY = 0  // Default to no verification
) (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Direct implementation of both AND gate styles
    assign out_assign = a & b;
    
    always @(*) begin
        out_alwaysblock = a & b;
    end

    // Simplified verification
    generate
        if (VERIFY) begin
            always @(*) begin
                if (out_assign !== out_alwaysblock) begin
                    $error("AND gate mismatch: a=%b, b=%b, assign=%b, always=%b",
                           a, b, out_assign, out_alwaysblock);
                end
            end
        end
    endgenerate
endmodule