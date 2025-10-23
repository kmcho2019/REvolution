module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    
    // shift_ena is high when counter hasn't reached zero
    assign shift_ena = (counter != 2'b00) || reset;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;  // Initialize to 3 (binary 11)
        end else if (counter != 2'b00) begin
            counter <= counter - 1;  // Decrement until zero
        end
        // When counter reaches zero, it stays there until next reset
    end

endmodule