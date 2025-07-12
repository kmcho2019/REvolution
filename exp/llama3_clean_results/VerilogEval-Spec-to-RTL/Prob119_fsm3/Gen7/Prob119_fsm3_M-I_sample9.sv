module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
reg [1:0] state;

// Combinational logic for next state
always @(*) begin
    case (state)
        2'b00: // State A
            state = in? 2'b01 : 2'b00;
        2'b01: // State B
            state = in? 2'b01 : 2'b10;
        2'b10: // State C
            state = in? 2'b11 : 2'b00;
        2'b11: // State D
            state = in? 2'b01 : 2'b10;
        default:
            state = 2'b00;
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= state; // Update state
    end
end

// Output logic
assign out = (state == 2'b11)? 1'b1 : 1'b0;

endmodule