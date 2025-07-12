module TopModule (
    output out
);
    reg [1:0] counter;
    
    initial begin
        counter = 2'b00;
    end
    
    always @(*) begin
        out = 1'b0;  // Output is always 0 regardless of counter
    end
    
    always #1 counter = counter + 1;  // Counter keeps ticking
endmodule