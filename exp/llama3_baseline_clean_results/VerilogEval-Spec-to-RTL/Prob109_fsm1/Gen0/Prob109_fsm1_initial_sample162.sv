module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state; // Using 2 bits for state (A=0, B=1)
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: // State A
            if (~in) 
                next_state = 2'b01; // Transition to B
            else 
                next_state = 2'b00; // Stay in A
        2'b01: // State B
            if (~in) 
                next_state = 2'b00; // Transition to A
            else 
                next_state = 2'b01; // Stay in B
        default: next_state = 2'b01; // Default to B
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Asynchronous reset to B
    end else begin
        state <= next_state;
    end
end

assign out = state[0]; // Since the state is represented as 2 bits, 
                       // but the output should be 1 bit, 
                       // we use the least significant bit of the state

endmodule