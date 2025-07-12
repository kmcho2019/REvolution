module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [7:0] byte1;
reg [7:0] byte2;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        done <= 1'b0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    state <= 2'b01; // BYTE1
                    byte1 <= in;
                end else begin
                    state <= 2'b00; // stay in IDLE
                end
            end
            2'b01: begin // BYTE1
                state <= 2'b10; // BYTE2
                byte2 <= in;
            end
            2'b10: begin // BYTE2
                state <= 2'b00; // back to IDLE
                out_bytes <= {in, byte2, byte1};
                done <= 1'b1;
            end
            default: begin
                state <= 2'b00; // default to IDLE
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (~reset) begin
        if (state!= 2'b10) begin
            done <= 1'b0;
        end
    end
end

endmodule