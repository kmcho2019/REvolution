module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // IDLE state
    end else begin
        case (state)
            2'b00: // IDLE state
                state <= x ? 2'b01 : 2'b00; // Transition to STATE1 if input is '1'
            2'b01: // STATE1 state
                state <= x ? 2'b01 : 2'b10; // Transition to STATE2 if input is '0'
            2'b10: // STATE2 state
                state <= x ? 2'b01 : 2'b00; // Transition to STATE1 if input is '1', otherwise IDLE
            default:
                state <= 2'b00; // Default to IDLE state
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x; // Assert output z when in STATE2 and input is '1'

endmodule