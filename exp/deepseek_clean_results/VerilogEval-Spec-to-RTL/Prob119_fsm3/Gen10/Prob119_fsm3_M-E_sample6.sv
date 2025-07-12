module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (acts as shift register)
    reg [1:0] state;

    // Shift input generation logic
    wire [1:0] shift_in;
    assign shift_in[1] = state[0] ^ (state[1] & in);
    assign shift_in[0] = (state == 2'b10) ? ~in : 
                        (state == 2'b11) ? in : 
                        (state == 2'b01) ? 1'b1 : in;

    // State update with shift operation and async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= 2'b00;  // Reset to state A
        else state <= {state[0], shift_in[0]};
    end

    // Output is MSB when in state D (11)
    assign out = (state == 2'b11);

endmodule