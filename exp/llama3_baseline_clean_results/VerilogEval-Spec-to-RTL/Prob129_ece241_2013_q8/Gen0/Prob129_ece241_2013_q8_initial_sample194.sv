module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
enum logic [1:0] {
    IDLE    = 2'b00,
    STATE1  = 2'b01,
    STATE2  = 2'b10
} state, next_state;

// Sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    z = 1'b0;
    case (state)
        IDLE: begin
            if (x == 1'b1) begin
                next_state = STATE1;
            end
        end
        STATE1: begin
            if (x == 1'b0) begin
                next_state = STATE2;
            end else if (x == 1'b1) begin
                next_state = STATE1;
            end
        end
        STATE2: begin
            if (x == 1'b1) begin
                next_state = IDLE;
                z = 1'b1;
            end else if (x == 1'b0) begin
                next_state = STATE2;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule