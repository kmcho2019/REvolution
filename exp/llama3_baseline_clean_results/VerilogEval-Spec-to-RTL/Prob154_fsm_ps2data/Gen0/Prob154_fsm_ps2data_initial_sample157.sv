module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // State register
reg [23:0] out_bytes_reg; // Register for out_bytes
reg done_reg; // Register for done signal

// Initialize state and out_bytes_reg on reset
always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    state <= 1;
                end
            end
            1: begin // RECEIVE_BYTE_1 state
                out_bytes_reg[15:8] <= in;
                state <= 2;
            end
            2: begin // RECEIVE_BYTE_2 state
                out_bytes_reg[7:0] <= in;
                done_reg <= 1;
                state <= 0; // Reset state after receiving a message
            end
            default: state <= 0;
        endcase
        if (state == 0 && !in[3]) begin // Stay in IDLE state if not in[3]
            done_reg <= 0;
        end
        if (state == 2 && done_reg) begin // Reset done signal after one cycle
            done_reg <= 0;
        end
    end
end

// Assign output signals
assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule