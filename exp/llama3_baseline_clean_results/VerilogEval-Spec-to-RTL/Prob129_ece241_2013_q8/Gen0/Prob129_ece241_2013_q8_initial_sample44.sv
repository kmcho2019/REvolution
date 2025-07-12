module TopModule (
    input           clk,
    input           aresetn,
    input           x,
    output          z
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    ONE_RECEIVED,
    ZERO_RECEIVED
} state_type;

state_type current_state;
state_type next_state;

// Sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (x) begin
                next_state = ONE_RECEIVED;
            end else begin
                next_state = IDLE;
            end
            z = 1'b0;
        end
        ONE_RECEIVED: begin
            if (x) begin
                next_state = ONE_RECEIVED;
            end else begin
                next_state = ZERO_RECEIVED;
            end
            z = 1'b0;
        end
        ZERO_RECEIVED: begin
            if (x) begin
                next_state = ONE_RECEIVED;
                z = 1'b1;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            z = 1'b0;
        end
    endcase
end

endmodule