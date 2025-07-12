module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state; // 4-bit state encoding for the sequence detection
reg [3:0] next_state;

// Initialize the FSM to the IDLE state
initial state = 4'b0000;

// Combinational logic for next state, optimized for sequence detection
always @(*) begin
    case(state)
        4'b0000: next_state = data ? 4'b0001 : 4'b0000;
        4'b0001: next_state = data ? 4'b0011 : 4'b0000;
        4'b0011: next_state = ~data ? 4'b0110 : 4'b0000;
        4'b0110: next_state = data ? 4'b1111 : 4'b0000;
        4'b1111: next_state = 4'b1111; // Final state
        default: next_state = 4'b0000;
    endcase
end

// Synchronous reset and state update, ensuring correct timing
always @(posedge clk) begin
    if(reset) begin
        state <= 4'b0000;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(next_state == 4'b1111) begin
            start_shifting <= 1;
        end else if(state != 4'b1111) begin
            start_shifting <= 0;
        end
    end
end

endmodule