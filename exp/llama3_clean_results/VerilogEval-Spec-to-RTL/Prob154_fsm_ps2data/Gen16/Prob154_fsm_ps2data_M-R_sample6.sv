module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

typedef enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state_t;

reg [1:0] state_reg;
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_bytes <= 0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    state_reg <= BYTE1;
                end else begin
                    state_reg <= IDLE;
                end
            end
            BYTE1: begin
                out_bytes[15:8] <= in;
                state_reg <= BYTE2;
            end
            BYTE2: begin
                out_bytes[7:0] <= in;
                state_reg <= IDLE;
            end
            default: begin
                state_reg <= IDLE;
            end
        endcase
    end
end

assign done = (state_reg == BYTE2);

endmodule