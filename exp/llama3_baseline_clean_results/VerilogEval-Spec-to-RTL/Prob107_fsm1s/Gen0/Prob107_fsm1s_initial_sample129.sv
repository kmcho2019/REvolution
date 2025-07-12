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
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // undefined state
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        B: begin
            if (in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (in == 1'b0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B; // default to reset state
    endcase
end

endmodule