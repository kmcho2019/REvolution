module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

assign done = (state == BYTE3);

endmodule