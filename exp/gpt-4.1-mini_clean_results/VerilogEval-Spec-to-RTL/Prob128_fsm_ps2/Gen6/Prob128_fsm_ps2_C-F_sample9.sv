module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // One-hot state encoding
    localparam WAIT_FOR_START = 3'b001;
    localparam BYTE2          = 3'b010;
    localparam BYTE3          = 3'b100;

    reg [2:0] state, next_state;

    // State register and done signal update
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done only one cycle after receiving third byte (i.e., when transitioning from BYTE3)
            done <= (state == BYTE3);
        end
    end

    // Next state logic combinational block
    always @(*) begin
        next_state = state; // default hold current state

        case (state)
            WAIT_FOR_START: begin
                // Wait until a valid first byte with in[3]=1 arrives
                if (in[3])
                    next_state = BYTE2;
            end
            BYTE2: begin
                // Accept second byte unconditionally, move to BYTE3
                next_state = BYTE3;
            end
            BYTE3: begin
                // After third byte, go back to waiting for next message start
                // No condition needed, transition immediately
                next_state = WAIT_FOR_START;
            end
            default: begin
                // Safety fallback to WAIT_FOR_START on undefined states
                next_state = WAIT_FOR_START;
            end
        endcase
    end

endmodule