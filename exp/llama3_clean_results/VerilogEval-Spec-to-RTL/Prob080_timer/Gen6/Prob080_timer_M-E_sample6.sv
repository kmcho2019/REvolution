module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

enum logic [1:0] {
    IDLE,
    COUNTING,
    TERMINAL_COUNT
} state, next_state;

reg [9:0] counter;

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (load) next_state = COUNTING;
        end
        COUNTING: begin
            if (load) next_state = COUNTING;
            else if (counter == 10'd0) next_state = TERMINAL_COUNT;
        end
        TERMINAL_COUNT: begin
            if (load) next_state = COUNTING;
        end
    endcase
end

always @(posedge clk) begin
    state <= next_state;
    case (next_state)
        IDLE: begin
            counter <= 10'd0;
        end
        COUNTING: begin
            if (load) counter <= data;
            else counter <= (counter == 10'd0) ? 10'd0 : counter - 1;
        end
        TERMINAL_COUNT: begin
            counter <= 10'd0;
        end
    endcase
end

assign tc = (state == TERMINAL_COUNT);

endmodule