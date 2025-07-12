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
        done <= 0;
        out_bytes <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    bytes <= {in, 16'd0};
                    state <= 2'b01;
                end
            end
            2'b01: begin // BYTE1 state
                bytes <= {bytes[15:0], in};
                state <= 2'b10;
            end
            2'b10: begin // BYTE2 state
                bytes <= {bytes[15:0], in};
                state <= 2'b11;
            end
            2'b11: begin // BYTE3 state
                bytes <= {bytes[15:0], in};
                out_bytes <= bytes;
                done <= 1;
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
        if (state != 2'b11) begin
            done <= 0;
        end
    end
end

endmodule