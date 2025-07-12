module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2 bits for 3 states: 00 (initial), 01 (seen '1'), 10 (seen '10')

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        case(state)
            2'b00: state <= x? 2'b01 : 2'b00; // From initial state, move to '1' state if input is '1'
            2'b01: state <= x? 2'b01 : 2'b10; // If in '1' state and input is '0', move to '10' state
            2'b10: state <= x? 2'b01 : 2'b00; // If in '10' state, reset to initial or move back to '1' state based on input
            default: state <= 2'b00; // Default to initial state for any other condition
        endcase
    end
end

// Output logic: Assert z when transitioning from '10' state to '1' state on a '1' input
assign z = (state == 2'b10) && x;

endmodule