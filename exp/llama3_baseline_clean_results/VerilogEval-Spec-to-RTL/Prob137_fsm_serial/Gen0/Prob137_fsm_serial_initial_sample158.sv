module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT
} state, next_state;

// Data register to store the received byte
logic [7:0] data;
logic [2:0] data_count;

// Done signal
logic done_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
        data_count <= 0;
    end else begin
        state <= next_state;
        if (done_reg) begin
            done_reg <= 0;
        end
        if (state == DATA_BITS && next_state == DATA_BITS) begin
            data_count <= data_count + 1;
        end else if (next_state == DATA_BITS) begin
            data_count <= 1;
        end else begin
            data_count <= 0;
        end
        if (next_state == DATA_BITS) begin
            data[data_count - 1] <= in;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (~in) begin
                next_state = START_BIT;
            end
        end
        START_BIT: begin
            next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (data_count == 8) begin
                next_state = STOP_BIT;
            end
        end
        STOP_BIT: begin
            if (in) begin
                next_state = IDLE;
                done_reg <= 1;
            end
        end
    endcase
end

assign done = done_reg;

endmodule