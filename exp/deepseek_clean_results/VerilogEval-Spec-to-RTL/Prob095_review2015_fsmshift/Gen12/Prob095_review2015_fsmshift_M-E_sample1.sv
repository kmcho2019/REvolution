module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;  // Needs to count 4->0 (3 bits sufficient)
    
    assign shift_ena = (counter != 3'b000);
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b100;  // Initialize to 4 on reset
        end else if (counter != 3'b000) begin
            counter <= counter - 1;  // Decrement until zero
        end
    end

endmodule