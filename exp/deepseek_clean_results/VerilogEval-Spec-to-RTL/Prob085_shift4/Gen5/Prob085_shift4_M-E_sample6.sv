module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    LOAD,
    SHIFT
} state_t;

state_t current_state, next_state;

// State transition logic
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: begin
            if (load) next_state = LOAD;
            else if (ena) next_state = SHIFT;
        end
        LOAD: next_state = IDLE;
        SHIFT: next_state = IDLE;
    endcase
end

// State register and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE;
        q <= 4'b0;
    end else begin
        current_state <= next_state;
        case (next_state)
            LOAD: q <= data;
            SHIFT: q <= {1'b0, q[3:1]};
            default: q <= q;  // IDLE maintains current value
        endcase
    end
end

endmodule