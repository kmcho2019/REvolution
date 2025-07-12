module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

typedef enum {OFF, ON} state_t;

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
    endcase
end

always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

endmodule