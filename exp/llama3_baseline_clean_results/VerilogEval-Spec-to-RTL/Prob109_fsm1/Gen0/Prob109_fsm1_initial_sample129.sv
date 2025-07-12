module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states
enum {B, A} state, next_state;

// Asynchronous reset
always @(areset or * ) begin
    if(areset) begin
        state = B;
    end else begin
        case(state)
            B: begin
                if(!in) next_state = A;
                else next_state = B;
            end
            A: begin
                if(!in) next_state = B;
                else next_state = A;
            end
            default: next_state = B;
        endcase
    end
end

// Synchronous update of state on clock edge
always @(posedge clk) begin
    if(!areset) state = next_state;
end

// Assign output based on current state
always @(*) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default to B if state is not recognized
    endcase
end

endmodule