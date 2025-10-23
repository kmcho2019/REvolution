module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {B, A} currentState, nextState;

// Initialize the state to B upon asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        currentState <= B;
    end else begin
        currentState <= nextState;
    end
end

// Determine the next state and output based on the current state and input
always_comb begin
    case(currentState)
        B: begin
            if(in == 1'b0) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        A: begin
            if(in == 1'b0) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        default: begin
            nextState = B; // Default to state B for any other condition
        end
    endcase
end

// Determine the output based on the current state (Moore machine property)
assign out = (currentState == B) ? 1'b1 : 1'b0;

endmodule