module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

typedef enum logic [1:0] {
    idle,
    start,
    data,
    stop
} state_t;

state_t state, next_state;

logic [2:0] data_cnt;
logic [7:0] byte;

assign done = (state == stop) && (in == 1'b1);

always_ff @(posedge clk) begin
    if (reset) begin
        state <= idle;
        data_cnt <= 0;
        byte <= 0;
    end else begin
        state <= next_state;
        if (next_state == start) begin
            data_cnt <= 0;
            byte <= 0;
        end else if (next_state == data) begin
            data_cnt <= data_cnt + 1;
            byte[data_cnt - 1] <= in;
        end else if (next_state == stop) begin
            out_byte <= byte;
        end
    end
end

always_comb begin
    next_state = state;
    case(state)
        idle: begin
            if (in == 1'b0) next_state = start;
        end
        start: begin
            next_state = data;
        end
        data: begin
            if (data_cnt == 8) next_state = stop;
            else if (in == 1'b1) next_state = idle; // Unexpected stop bit
        end
        stop: begin
            next_state = idle;
        end
    endcase
end

endmodule