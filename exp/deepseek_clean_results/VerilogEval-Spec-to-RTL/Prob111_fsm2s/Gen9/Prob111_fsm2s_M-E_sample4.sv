module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] state_shift;

    // Shift register input logic
    wire shift_in;
    assign shift_in = (state_shift[1] & ~k) | (~state_shift[1] & j);

    // Shift register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01;  // OFF state
        end else begin
            state_shift <= {state_shift[0], shift_in};
        end
    end

    // Output is the MSB of shift register
    assign out = state_shift[1];

endmodule