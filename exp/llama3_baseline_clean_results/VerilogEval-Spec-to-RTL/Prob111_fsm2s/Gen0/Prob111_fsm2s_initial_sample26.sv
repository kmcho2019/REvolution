module TopModule(
    input           clk,
    input           reset,
    input           j,
    input           k,
    output logic    out
);

typedef enum logic [0:0] {
    OFF,
    ON
} state_t;

state_t state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
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
        default: next_state = OFF;
    endcase
end

always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule