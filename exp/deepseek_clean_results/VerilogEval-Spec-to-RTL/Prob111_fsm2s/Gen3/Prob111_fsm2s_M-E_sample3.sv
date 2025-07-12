module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] state_shift;

    // Output is MSB of shift register
    assign out = state_shift[1];

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b00;  // Reset to OFF state
        end else begin
            // Rotate left and update LSB based on current state and inputs
            state_shift <= {state_shift[0], 
                           out ? (k ? 1'b0 : 1'b1) :  // ON state logic
                                 (j ? 1'b1 : 1'b0)};  // OFF state logic
        end
    end

endmodule