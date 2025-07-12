module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [23:0] stored_bytes;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        stored_bytes <= 24'h0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1'b1) begin
                    stored_bytes[7:0] <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                stored_bytes[15:8] <= in;
                state <= 2;
            end
            2: begin // BYTE2
                stored_bytes[23:16] <= in;
                state <= 3;
            end
            3: begin // DONE
                out_bytes <= stored_bytes;
                done <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (!reset && state!= 3) begin
        done <= 0;
    end
end

endmodule