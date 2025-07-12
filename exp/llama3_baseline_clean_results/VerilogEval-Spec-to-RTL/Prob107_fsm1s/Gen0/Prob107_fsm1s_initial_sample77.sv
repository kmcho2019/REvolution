module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {B, A} state, next_state;

// Output logic
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

// Next state logic
always_comb begin
    case(state)
        B: case(in)
                1'b0: next_state = A;
                1'b1: next_state = B;
                default: next_state = B;
            endcase
        A: case(in)
                1'b0: next_state = B;
                1'b1: next_state = A;
                default: next_state = A;
            endcase
        default: next_state = B;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule