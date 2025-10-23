module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      out
);

// Define the states
parameter B = 1'b0, A = 1'b1;

// Declare the current state and next state variables
reg [0:0] current_state, next_state;

// Combinational logic for the next state and output
always @(*) begin
    case(current_state)
        B: begin
            if (!in) next_state = A;
            else     next_state = B;
            out = 1'b1;
        end
        A: begin
            if (!in) next_state = B;
            else     next_state = A;
            out = 1'b0;
        end
        default: begin
            next_state = B;
            out = 1'b1;
        end
    endcase
end

// Sequential logic for the current state
always @(posedge clk) begin
    if (reset) current_state <= B;
    else       current_state <= next_state;
end

endmodule