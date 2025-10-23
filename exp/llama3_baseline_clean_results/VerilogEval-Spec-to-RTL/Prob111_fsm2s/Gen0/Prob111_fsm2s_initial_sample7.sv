module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [1:0] state; // 2 states: 2'b00 (OFF), 2'b01 (ON)
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // State OFF
            if(j == 1'b1)
                next_state = 2'b01; // Transition to ON
            else
                next_state = 2'b00; // Stay in OFF
        end
        2'b01: begin // State ON
            if(k == 1'b1)
                next_state = 2'b00; // Transition to OFF
            else
                next_state = 2'b01; // Stay in ON
        end
        default: next_state = 2'b00; // Default state
    endcase
end

always @(posedge clk) begin
    if(reset) begin // Active-high synchronous reset
        state <= 2'b00; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: out = 1'b0; // Output for OFF state
        2'b01: out = 1'b1; // Output for ON state
        default: out = 1'b0; // Default output
    endcase
end

endmodule