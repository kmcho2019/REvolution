module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                 // State register for FSM
reg [1:0] next_state;            // Next state register for FSM

always @ (*) begin
    case (state)
        2'b00: next_state = 2'b01; // State 0 to State 1
        2'b01: next_state = 2'b10; // State 1 to State 2
        2'b10: next_state = 2'b11; // State 2 to State 3
        2'b11: next_state = 2'b00; // State 3 back to State 0
        default: next_state = 2'b00;
    endcase
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;           // Reset state to 0 on reset
    end else begin
        state <= next_state;      // Update state on clock edge
    end
end

assign valid_out = (state == 2'b00); // Set valid_out when in State 0
assign dout = d[3 - state];         // Output bit based on current state

endmodule