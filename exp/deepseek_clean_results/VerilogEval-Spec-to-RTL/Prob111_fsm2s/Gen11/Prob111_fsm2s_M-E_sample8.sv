module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] state_shift;  // MSB represents current state

    // Shift register with feedback logic
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b00;  // Reset to OFF state
        end else begin
            // Rotate left and insert new LSB based on transition logic
            state_shift <= {state_shift[0], 
                          (state_shift[1] ? ~k : j)};
        end
    end

    // Output is the MSB of the shift register
    assign out = state_shift[1];

endmodule