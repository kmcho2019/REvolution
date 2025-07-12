module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    IDLE    = 2'b00,
    SEEN_1  = 2'b01,
    SEEN_10 = 2'b10
} state_t;

// State register
state_t state;
state_t next_state;

// Output logic
assign z = (state == SEEN_10) && x;

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = SEEN_10;
            end
        end
        SEEN_10: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule