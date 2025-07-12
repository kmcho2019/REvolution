module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
typedef enum logic [0:0] {
    OFF,
    ON
} state_t;

// Define current state and next state registers
state_t current_state;
state_t next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Combinatorial logic block
always_comb begin
    case (current_state)
        OFF: begin
            if (j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule