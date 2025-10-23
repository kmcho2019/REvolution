module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
typedef enum logic [1:0] {B, A} state_t;
state_t state, next_state;

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        B: begin
            if(!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if(!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B; // Default to state B
    endcase
end

// Output logic
always @(*) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default output when in state B
    endcase
end

endmodule