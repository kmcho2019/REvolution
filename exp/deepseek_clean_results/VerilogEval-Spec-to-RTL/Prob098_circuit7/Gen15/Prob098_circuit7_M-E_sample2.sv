module TopModule(input clk, input a, output q);
    reg state;
    
    assign q = state;
    
    always @(posedge clk) begin
        if (!state && !a) begin
            state <= 1'b1;  // Set q to 1 on first a=0
        end
        else if (state && a) begin
            state <= 1'b0;   // Set q to 0 on first a=1 after q was 1
        end
    end
endmodule