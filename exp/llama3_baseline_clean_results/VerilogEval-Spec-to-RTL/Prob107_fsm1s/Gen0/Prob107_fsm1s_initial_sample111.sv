module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {B, A} state, next_state;

// Assign output based on current state
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// State transition logic
always_comb begin
    case (state)
        B: begin
            case (in)
                1'b0: next_state = A;
                1'b1: next_state = B;
            endcase
        end
        A: begin
            case (in)
                1'b0: next_state = B;
                1'b1: next_state = A;
            endcase
        end
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule