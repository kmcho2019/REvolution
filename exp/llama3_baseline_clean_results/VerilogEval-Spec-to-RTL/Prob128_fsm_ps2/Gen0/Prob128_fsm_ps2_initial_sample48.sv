module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // IDLE (2'b00), BYTE1 (2'b01), BYTE2 (2'b10)
reg [7:0] byte1, byte2; // storing bytes for message

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // transition to BYTE1 state
                end else begin
                    state <= 2'b00; // stay in IDLE state
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // transition to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                state <= 2'b00; // transition back to IDLE state
                done <= 1'b1; // signal receipt of a message
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        // nothing to do here
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    // first byte of message, do nothing
                end else begin
                    // stay in IDLE state, do nothing
                end
            end
            2'b01: begin // BYTE1 state
                // second byte of message, do nothing
            end
            2'b10: begin // BYTE2 state
                // signal receipt of a message and reset done
                done <= 1'b0;
            end
            default: ;
        endcase
    end
end

endmodule