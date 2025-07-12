module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] state; // 2-bit state variable (IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10)

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to IDLE
    end
    else begin
        case(state)
            2'b00: // IDLE state
                if(in[3]) begin
                    state <= 2'b01; // Transition to BYTE1 if in[3] = 1
                end
            2'b01: // BYTE1 state
                state <= 2'b10; // Transition to BYTE2
            2'b10: // BYTE2 state
                state <= in[3]? 2'b01 : 2'b10; // Stay in BYTE2 if in[3] = 1, else stay in BYTE2
            default:
                state <= 2'b00; // Default to IDLE state
        endcase
    end
end

assign done = (state == 2'b10); // Assert 'done' signal when in BYTE2 state

endmodule