module TopModule (
    output reg zero
);
    // Clock input (though unused in this simple case)
    wire clk;
    
    // Implement zero using a permanently reset D flip-flop
    always @(posedge clk) begin
        zero <= 1'b0; // Continuously drive zero
    end
    
    // Alternative implementation showing explicit reset
    /*
    wire reset = 1'b1; // Permanent reset
    always @(posedge clk or posedge reset) begin
        if (reset) zero <= 1'b0;
        else zero <= 1'b0; // Always zero regardless
    end
    */
endmodule