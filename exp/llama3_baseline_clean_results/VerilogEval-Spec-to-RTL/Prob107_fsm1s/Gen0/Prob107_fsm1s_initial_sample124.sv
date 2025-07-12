module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Enumerate the states
enum logic [0:0] {B, A} state, nextState;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= nextState;
    end
end

// Combinational logic
always_comb begin
    case (state)
        B: begin
            if (!in) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        A: begin
            if (!in) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        default: nextState = B;
    endcase
    
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule