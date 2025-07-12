module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] state_shift;

    // Next state logic: rotate left with new bit determined by current state and inputs
    wire next_bit = (state_shift[0] == 0) ? j : ~k;

    always @(posedge clk) begin
        if (reset)
            state_shift <= 2'b01;  // OFF state
        else
            state_shift <= {state_shift[0], next_bit};
    end

    // Output is the LSB of the shift register
    assign out = state_shift[0];

endmodule