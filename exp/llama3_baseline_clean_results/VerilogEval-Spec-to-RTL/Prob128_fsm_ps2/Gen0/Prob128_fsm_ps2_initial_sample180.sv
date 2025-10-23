module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

// Define states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// Internal registers and wires
logic [1:0] counter;
logic done_reg;

// FSM logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = BYTE3;
        BYTE3: begin
            next_state = IDLE;
            done_reg = 1'b1;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        done_reg <= (state == BYTE3) ? 1'b1 : 1'b0;
    end
end

// Continuous assignment
assign done = done_reg;

endmodule