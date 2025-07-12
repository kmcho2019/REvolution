module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // BYTE1
                    out_bytes <= {in, 16'b0};
                end else begin
                    state <= 2'b00; // IDLE
                end
            end
            2'b01: begin // BYTE1
                state <= 2'b10; // BYTE2
                out_bytes <= {out_bytes[15:0], in};
            end
            2'b10: begin // BYTE2
                state <= 2'b11; // DONE
                out_bytes <= {out_bytes[7:0], in, 8'b0};
                done <= 1'b1;
            end
            2'b11: begin // DONE
                state <= 2'b00; // IDLE
                done <= 1'b0;
            end
            default: begin
                state <= 2'b00; // IDLE
            end
        endcase
    end
end

endmodule