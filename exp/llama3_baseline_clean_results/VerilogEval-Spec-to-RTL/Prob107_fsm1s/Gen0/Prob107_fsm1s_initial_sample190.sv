module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum {B, A} state, next_state;

// Initialize the state
initial state = B;

// Sequential logic for state transition
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case (state)
        B: begin
            if (in == 0) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
            out <= 1'b1;
        end
        A: begin
            if (in == 0) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
            out <= 1'b0;
        end
        default: begin
            next_state <= B;
            out <= 1'b1;
        end
    endcase
end

endmodule