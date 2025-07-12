module TopModule(
    output reg out // Output port that always drives 0
);
    // Initialize a local variable to 0, ensuring the output remains at logic low
    initial out = 1'b0;
    
    // Use an always block to continuously drive the output to 0
    always @(out) // Sensitivity list includes the output itself
    begin
        out = 1'b0; // Drive the output to 0 within the always block
    end
endmodule