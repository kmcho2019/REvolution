module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state_reg; // Using a 2-bit register for pipelining
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 2'b00; // Reset to state B
    end else begin
        state_reg <= next_state;
    end
end

always @(*) begin
    case (state_reg)
        2'b00: begin // State B
            if (in == 0) begin
                next_state = 2'b01; // Transition to state A
            end else begin
                next_state = 2'b00; // Stay in state B
            end
        end
        2'b01: begin // State A
            if (in == 0) begin
                next_state = 2'b00; // Transition to state B
            end else begin
                next_state = 2'b01; // Stay in state A
            end
        end
        default: begin
            next_state = 2'b00; // Default to state B
        end
    endcase
end

assign out = (state_reg == 2'b00) ? 1'b1 : 1'b0; // Output based on the current state

endmodule