module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define states
enum logic [2:0] {
    IDLE      = 3'b000,
    MATCH_1   = 3'b001,
    MATCH_11  = 3'b010,
    MATCH_110 = 3'b011,
    MATCH_1101 = 3'b100,
    FOUND     = 3'b101
} state, next_state;

// Output logic
assign start_shifting = (state == MATCH_1101 || state == FOUND);

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state = MATCH_1;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH_1: begin
            if (data == 1) begin
                next_state = MATCH_11;
            end else if (data == 0) begin
                next_state = MATCH_110;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH_11: begin
            if (data == 0) begin
                next_state = MATCH_110;
            end else begin
                next_state = MATCH_1;
            end
        end
        MATCH_110: begin
            if (data == 1) begin
                next_state = MATCH_1101;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH_1101: begin
            next_state = FOUND;
        end
        FOUND: begin
            next_state = FOUND;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule