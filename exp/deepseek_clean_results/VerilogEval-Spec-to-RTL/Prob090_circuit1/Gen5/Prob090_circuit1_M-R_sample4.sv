module TopModule (
    input wire a,
    input wire b,
    output wire q
);
    // Behavioral implementation using always block
    reg q_reg;
    
    always @(*) begin
        q_reg = a & b;
    end
    
    assign q = q_reg;
endmodule