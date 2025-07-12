module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

enum logic [1:0] {IDLE, RECEIVING, DONE_STATE} state, next_state;
logic [1:0] byte_count, next_byte_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte_count <= 0;
    end else begin
        state <= next_state;
        byte_count <= next_byte_count;
    end
end

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = RECEIVING;
                next_byte_count = 1;
            end
        end
        RECEIVING: begin
            next_byte_count = byte_count + 1;
            if (byte_count == 2) begin
                next_state = DONE_STATE;
            end
        end
        DONE_STATE: begin
            next_state = IDLE;
        end
    endcase
end

assign done = (state == DONE_STATE);

endmodule