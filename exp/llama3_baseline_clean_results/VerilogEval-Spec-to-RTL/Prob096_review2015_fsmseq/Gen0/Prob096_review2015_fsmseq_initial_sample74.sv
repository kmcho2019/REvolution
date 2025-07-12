module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Define the states
enum logic [2:0] {
    IDLE = 3'b000,
    STATE1 = 3'b001,
    STATE2 = 3'b010,
    STATE3 = 3'b011,
    FOUND = 3'b100
} state, next_state;

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
            if (data) begin
                next_state = STATE1;
            end else begin
                next_state = IDLE;
            end
        end
        STATE1: begin
            if (data) begin
                next_state = STATE2;
            end else begin
                next_state = IDLE;
            end
        end
        STATE2: begin
            if (!data) begin
                next_state = STATE3;
            end else begin
                next_state = STATE1;
            end
        end
        STATE3: begin
            if (data) begin
                next_state = FOUND;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
    endcase
end

// Output logic
assign start_shifting = (state == FOUND);

endmodule