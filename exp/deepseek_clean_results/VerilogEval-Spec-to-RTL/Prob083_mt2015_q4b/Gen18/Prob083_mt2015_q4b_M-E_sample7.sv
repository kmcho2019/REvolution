module TopModule (
    input x,
    input y,
    output z
);
    reg state;
    
    initial begin
        state = 1'b1;  // Initial state matches waveform
    end
    
    always @(*) begin
        if (x & y) begin
            state = 1'b1;  // Reset condition
        end
        else if ((x & ~y) | (~x & y)) begin
            state = 1'b0;  // Set condition
        end
    end
    
    assign z = state;
endmodule