module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b00: begin // Idle state
            if (in[3] == 1'b1) begin
                nextState = 2'b01; // Transition to Byte1 state
            end else begin
                nextState = 2'b00; // Stay in Idle state
            end
        end
        2'b01: begin // Byte1 state
            nextState = 2'b10; // Transition to Byte2 state
        end
        2'b10: begin // Byte2 state
            nextState = 2'b11; // Transition to Byte3 state
        end
        2'b11: begin // Byte3 state
            nextState = 2'b00; // Transition to Idle state
        end
        default: begin
            nextState = 2'b00; // Default to Idle state
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= 2'b00; // Reset to Idle state
    end else begin
        state <= nextState; // Update state
    end
end

assign done = (state == 2'b11)? 1'b1 : 1'b0; // Signal done in Byte3 state

endmodule