module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

enum logic [1:0] {IDLE, BYTE1, BYTE2} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    next_state <= BYTE1;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE1: begin
                out_bytes[15:8] <= in;
                next_state <= BYTE2;
            end
            BYTE2: begin
                out_bytes[7:0] <= in;
                next_state <= IDLE;
            end
        endcase
        done <= (state == BYTE2);
    end
end

endmodule