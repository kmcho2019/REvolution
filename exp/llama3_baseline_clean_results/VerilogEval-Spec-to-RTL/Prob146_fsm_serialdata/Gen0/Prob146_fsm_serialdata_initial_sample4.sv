module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [2:0] {
    IDLE,
    RECEIVE_BYTE,
    VERIFY_STOP
} state, next_state;

logic [7:0] byte;
logic [2:0] bit_count;

always_comb begin
    next_state = state;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (in == 1'b0) begin
                next_state = RECEIVE_BYTE;
            end
            else begin
                next_state = IDLE;
            end
        end
        RECEIVE_BYTE: begin
            if (bit_count == 3'd7) begin
                next_state = VERIFY_STOP;
            end
            else begin
                next_state = RECEIVE_BYTE;
            end
        end
        VERIFY_STOP: begin
            if (in == 1'b1) begin
                done = 1'b1;
                next_state = IDLE;
            end
            else begin
                next_state = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte <= 8'd0;
        bit_count <= 3'd0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                byte <= 8'd0;
                bit_count <= 3'd0;
            end
            RECEIVE_BYTE: begin
                byte <= {byte[6:0], in};
                bit_count <= bit_count + 1'b1;
            end
            VERIFY_STOP: begin
                out_byte <= byte;
            end
        endcase
    end
end

endmodule