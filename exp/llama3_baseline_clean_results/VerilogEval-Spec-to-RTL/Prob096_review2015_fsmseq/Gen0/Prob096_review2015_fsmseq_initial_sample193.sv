module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Enumerate the states
    enum logic [2:0] {IDLE, GOT_1, GOT_11, GOT_110, GOT_1101} state, next_state;

    // Initial state
    initial state = IDLE;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 0;
        end else begin
            state <= next_state;
            if (state == GOT_1101) begin
                start_shifting <= 1;
            end
        end
    end

    // Combinational logic
    always @* begin
        case(state)
            IDLE: begin
                if (data == 1'b1) begin
                    next_state = GOT_1;
                end else begin
                    next_state = IDLE;
                end
            end
            GOT_1: begin
                if (data == 1'b1) begin
                    next_state = GOT_11;
                end else if (data == 1'b0) begin
                    next_state = GOT_110;
                end else begin
                    next_state = GOT_1;
                end
            end
            GOT_11: begin
                if (data == 1'b0) begin
                    next_state = GOT_110;
                end else begin
                    next_state = GOT_1;
                end
            end
            GOT_110: begin
                if (data == 1'b1) begin
                    next_state = GOT_1101;
                end else begin
                    next_state = IDLE;
                end
            end
            GOT_1101: begin
                next_state = GOT_1101;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule