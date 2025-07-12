module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states of the Moore machine
enum logic [0:0] {B, A} current_state, next_state;

// State transition logic
always_comb begin
    case (current_state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B;
    endcase
end

// Update current state on positive edge of clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Assign output based on current state
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule