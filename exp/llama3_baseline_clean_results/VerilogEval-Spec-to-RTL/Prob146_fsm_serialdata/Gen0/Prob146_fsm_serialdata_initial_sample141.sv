module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// State machine states
enum logic [2:0] {
    IDLE,
    RECEIVE,
    VERIFY_STOP,
    INVALID
} state, next_state;

// Internal signals
logic [2:0] bit_count;
logic [7:0] byte_in;

always_comb begin
    next_state = state;
    done = 1'b0;

    case (state)
        IDLE: begin
            if (~in) begin
                next_state = RECEIVE;
            end
        end
        RECEIVE: begin
            if (bit_count == 8) begin
                next_state = VERIFY_STOP;
            end
        end
        VERIFY_STOP: begin
            if (in) begin
                done = 1'b1;
                next_state = IDLE;
            end else begin
                next_state = INVALID;
            end
        end
        INVALID: begin
            if (in) begin
                next_state = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 3'b000;
        out_byte <= 8'b0;
    end else begin
        state <= next_state;
        if (state == RECEIVE) begin
            byte_in[bit_count] <= in;
            bit_count <= bit_count + 1'b1;
        end
        if (state == VERIFY_STOP) begin
            out_byte <= byte_in;
        end
        if (state == IDLE) begin
            bit_count <= 3'b000;
            out_byte <= 8'b0;
        end
        if (state == INVALID) begin
            bit_count <= 3'b000;
            out_byte <= 8'b0;
        end
    end
end

endmodule