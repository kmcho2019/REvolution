module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // idle, byte1, byte2, done
reg [7:0] byte1, byte2, byte3; // registers to store the bytes
reg [23:0] out_bytes_reg; // register to store the output
reg done_reg; // register to store the done signal

always @(posedge clk) begin
    if (reset) begin // reset the FSM
        state <= 0; // idle state
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (in[3] == 1) begin // if the input byte has in[3]=1
                    byte1 <= in; // store the input byte
                    state <= 1; // move to the byte1 state
                end
            end
            1: begin // byte1 state
                byte2 <= in; // store the input byte
                state <= 2; // move to the byte2 state
            end
            2: begin // byte2 state
                byte3 <= in; // store the input byte
                state <= 3; // move to the done state
            end
            3: begin // done state
                out_bytes_reg <= {byte1, byte2, byte3}; // output the 3-byte message
                done_reg <= 1; // signal the receipt of a message
                state <= 0; // move back to the idle state
            end
            default: begin // invalid state
                state <= 0; // move to the idle state
            end
        endcase
        if (state != 3) begin // if not in the done state
            done_reg <= 0; // deassert the done signal
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule