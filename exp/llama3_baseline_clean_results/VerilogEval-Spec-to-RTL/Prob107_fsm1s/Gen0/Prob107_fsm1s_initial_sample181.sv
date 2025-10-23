module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
enum {B, A} state, next_state;

// Assign the output based on the current state
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// Determine the next state
always_ff @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        case(state)
            B: begin
                if(!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if(!in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
        endcase
    end
end

endmodule