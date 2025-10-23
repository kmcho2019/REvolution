module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    IDLE,
    GOT_1,
    GOT_10
} state_t;

state_t state, next_state;

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = GOT_1;
            end else begin
                next_state = IDLE;
            end
        end
        GOT_1: begin
            if (!x) begin
                next_state = GOT_10;
            end else begin
                next_state = GOT_1;
            end
        end
        GOT_10: begin
            if (x) begin
                next_state = GOT_1;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign z = (state == GOT_10) && x;

endmodule