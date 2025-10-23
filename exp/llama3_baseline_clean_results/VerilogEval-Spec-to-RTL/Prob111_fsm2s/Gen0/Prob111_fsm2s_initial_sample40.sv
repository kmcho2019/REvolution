module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

typedef enum logic [0:0] {
    OFF,
    ON
} state_type;

state_type current_state;
state_type next_state;

always_comb begin
    case(current_state)
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

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case(current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

endmodule