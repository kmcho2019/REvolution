module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Pattern matching registers
    reg match_1;    // First '1' detected
    reg match_11;   // '11' detected
    reg match_110;  // '110' detected
    reg match_1101; // Final pattern detected

    always @(posedge clk) begin
        if (reset) begin
            match_1 <= 1'b0;
            match_11 <= 1'b0;
            match_110 <= 1'b0;
            match_1101 <= 1'b0;
        end else if (!match_1101) begin
            // First level: look for '1'
            match_1 <= data;
            
            // Second level: look for '11'
            match_11 <= match_1 && data;
            
            // Third level: look for '110'
            match_110 <= match_11 && !data;
            
            // Final level: look for '1101'
            match_1101 <= match_110 && data;
        end
    end

    assign start_shifting = match_1101;

endmodule