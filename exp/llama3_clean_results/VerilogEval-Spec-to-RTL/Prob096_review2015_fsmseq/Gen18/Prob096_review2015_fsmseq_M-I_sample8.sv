module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state encoding for 5 states (including the final state)
reg [2:0] next_state;

// Initialize the FSM to the IDLE state
initial state = 3'b000;

// Combinational logic for next state, optimized for fewer operations
always @(*) begin
    case(state)
        3'b000: next_state = data ? 3'b001 : 3'b000; 
        3'b001: next_state = data ? 3'b010 : 3'b000; 
        3'b010: next_state = ~data ? 3'b011 : 3'b010; 
        3'b011: next_state = data ? 3'b100 : 3'b000; 
        3'b100: next_state = 3'b100; 
        default: next_state = 3'b000; 
    endcase
end

// Synchronous reset and state update, ensuring correct timing
always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000; 
        start_shifting <= 0; 
    end else begin
        state <= next_state; 
        if(next_state == 3'b100) begin
            start_shifting <= 1; 
        end else if(state != 3'b100) begin
            start_shifting <= 0; 
        end
    end
end

endmodule