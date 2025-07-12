module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // One-hot encoding of states:
    // S_IDLE: waiting for in[3] == 1 (start of message)
    // S_BYTE2: received 1st byte
    // S_BYTE3: received 2nd byte
    localparam S_IDLE  = 3'b001;
    localparam S_BYTE2 = 3'b010;
    localparam S_BYTE3 = 3'b100;

    reg [2:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            S_IDLE: begin
                if (in[3])
                    next_state = S_BYTE2; // start of message detected
                else
                    next_state = S_IDLE;
            end
            S_BYTE2: next_state = S_BYTE3;
            S_BYTE3: begin
                // After third byte, look for next message start byte immediately
                if (in[3])
                    next_state = S_BYTE2;
                else
                    next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // Sequential state and done update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // done asserted for 1 cycle immediately after receiving 3rd byte
            done <= (state == S_BYTE3);
        end
    end

endmodule