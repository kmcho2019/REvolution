module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
parameter B = 1'b0, A = 1'b1;

// Current state register
reg state;

// Initialize state to B (out=1) on reset
initial state = B;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (~in) begin
                    state <= A;
                end
            end
            A: begin
                if (~in) begin
                    state <= B;
                end
            end
        endcase
    end
end

// Output logic based on current state
always @(*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

endmodule