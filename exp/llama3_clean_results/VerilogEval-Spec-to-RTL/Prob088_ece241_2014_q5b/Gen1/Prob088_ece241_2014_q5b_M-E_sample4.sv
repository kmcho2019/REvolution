module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoded state
reg [1:0] next_state; // Next state

// LUT for next state and output
always @(*) begin
    case ({state, x})
        3'b001: begin // State A, x = 0
            next_state = 2'b01; // Stay in state A
            z = 1'b0;
        end
        3'b011: begin // State A, x = 1
            next_state = 2'b10; // Transition to state B
            z = 1'b1;
        end
        3'b101: begin // State B, x = 0
            next_state = 2'b10; // Stay in state B
            z = 1'b1;
        end
        3'b111: begin // State B, x = 1
            next_state = 2'b10; // Stay in state B
            z = 1'b0;
        end
        default: begin
            next_state = 2'b01; // Default to state A
            z = 1'b0;
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset into state A
    end else begin
        state <= next_state;
    end
end

endmodule