module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
    reg [23:0] message; // stores the received message
    reg [23:0] out_bytes_reg; // stores the output message
    reg done_reg; // stores the done signal

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // IDLE
            message <= 0;
            out_bytes_reg <= 0;
            done_reg <= 0;
        end else begin
            case (state)
                0: begin // IDLE
                    if (in[3]) begin
                        message[7:0] <= in;
                        state <= 1; // BYTE1
                    end
                end
                1: begin // BYTE1
                    message[15:8] <= in;
                    state <= 2; // BYTE2
                end
                2: begin // BYTE2
                    message[23:16] <= in;
                    state <= 3; // BYTE3
                end
                3: begin // BYTE3
                    out_bytes_reg <= message;
                    done_reg <= 1;
                    state <= 0; // IDLE
                end
                default: state <= 0; // IDLE
            endcase
            if (state != 3) begin // not in BYTE3
                done_reg <= 0;
            end
        end
    end

    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule