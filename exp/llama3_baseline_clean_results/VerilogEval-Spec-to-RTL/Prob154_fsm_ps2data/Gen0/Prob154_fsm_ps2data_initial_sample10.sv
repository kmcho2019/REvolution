module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [23:0] bytes;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            case (state)
                2'b00: begin // IDLE state
                    if (in[3] == 1'b1) begin
                        bytes[7:0] <= in;
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                    done <= 1'b0;
                end
                2'b01: begin // BYTE1 state
                    bytes[15:8] <= in;
                    state <= 2'b10;
                    done <= 1'b0;
                end
                2'b10: begin // BYTE2 state
                    bytes[23:16] <= in;
                    state <= 2'b00;
                    done <= 1'b1;
                    out_bytes <= bytes;
                end
                default: state <= 2'b00;
            endcase
        end
    end

endmodule