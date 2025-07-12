module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

typedef enum logic [2:0] {
    S000, S001, S010, S011, S100
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        S000: begin
            if (!x) begin
                next_state = S000;
            end else begin
                next_state = S001;
            end
        end
        S001: begin
            if (!x) begin
                next_state = S001;
            end else begin
                next_state = S100;
            end
        end
        S010: begin
            if (!x) begin
                next_state = S010;
            end else begin
                next_state = S001;
            end
        end
        S011: begin
            if (!x) begin
                next_state = S001;
            end else begin
                next_state = S010;
            end
        end
        S100: begin
            if (!x) begin
                next_state = S011;
            end else begin
                next_state = S100;
            end
        end
        default: next_state = S000;
    endcase
end

always_comb begin
    case (current_state)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0;
    endcase
end

endmodule