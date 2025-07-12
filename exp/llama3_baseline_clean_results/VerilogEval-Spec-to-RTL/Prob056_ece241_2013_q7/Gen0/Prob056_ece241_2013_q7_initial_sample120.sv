module TopModule(clk, j, k, Q);
    input clk, j, k;
    output Q;
    reg Q; // Declare Q as a reg to hold the state

    always @(posedge clk) // Trigger at the positive edge of clk
    begin
        // Update Q based on the truth table
        if (j == 0 && k == 0) 
            Q <= Q; // No change, Q remains Qold
        else if (j == 0 && k == 1) 
            Q <= 0;
        else if (j == 1 && k == 0) 
            Q <= 1;
        else // j == 1 && k == 1
            Q <= ~Q; // Toggle Q
    end
endmodule