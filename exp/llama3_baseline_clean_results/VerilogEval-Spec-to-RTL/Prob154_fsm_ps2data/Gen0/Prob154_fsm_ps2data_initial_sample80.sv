module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // idle (2'b00), byte1 (2'b01), byte2 (2'b10), done (2'b11)
reg [7:0] byte1, byte2, byte3;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // idle
        done <= 1'b0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // byte1
                end
            end
            2'b01: begin // byte1
                byte2 <= in;
                state <= 2'b10; // byte2
            end
            2'b10: begin // byte2
                byte3 <= in;
                state <= 2'b11; // done
            end
            2'b11: begin // done
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
                state <= 2'b00; // idle
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state!= 2'b11) begin
        done <= 1'b0;
    end
end

endmodule