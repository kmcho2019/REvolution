module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

typedef enum logic [1:0] {
    OFF,
    ON
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: begin
            next_state = OFF;
        end
    endcase
end

always_comb begin
    case (state)
        OFF: out = 0;
        ON:  out = 1;
        default: out = 0;
    endcase
end

endmodule