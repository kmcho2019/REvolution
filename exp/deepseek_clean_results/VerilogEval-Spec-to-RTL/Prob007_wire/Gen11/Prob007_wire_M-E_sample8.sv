module TopModule(input in, output out);
    reg q;
    
    always @(in) begin
        q <= in;  // Transparent latch behavior (level-sensitive)
    end
    
    assign out = q;
endmodule