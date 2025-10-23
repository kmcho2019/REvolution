module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum {B, A} [0:0] state, next_state;

// Combinational logic for next state and output
always_comb begin
    case(state)
        B: begin
            if(in == 1'b0) next_state = A;
            else next_state = B;
        end
        A: begin
            if(in == 1'b0) next_state = B;
            else next_state = A;
        end
    endcase
    
    // Output is determined by the current state
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule