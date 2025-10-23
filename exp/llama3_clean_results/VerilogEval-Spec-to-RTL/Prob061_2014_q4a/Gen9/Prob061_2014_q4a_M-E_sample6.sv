module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

enum logic [1:0] {IDLE, SHIFTING, LOADING} state, next_state;

always @(*) begin
    case(state)
        IDLE: begin
            if (L) begin
                next_state = LOADING;
            end else if (E) begin
                next_state = SHIFTING;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFTING: begin
            if (L) begin
                next_state = LOADING;
            end else if (!E) begin
                next_state = IDLE;
            end else begin
                next_state = SHIFTING;
            end
        end
        LOADING: begin
            if (!L) begin
                next_state = IDLE;
            end else begin
                next_state = LOADING;
            end
        end
    endcase
end

always @(posedge clk) begin
    state <= next_state;
    case(state)
        IDLE: begin
            // No action
        end
        SHIFTING: begin
            Q <= w;
        end
        LOADING: begin
            Q <= R;
        end
    endcase
end

initial begin
    state = IDLE;
end

endmodule