module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state;  // current state
reg [0:0] next_state;  // next state

// State encoding
parameter A = 0;
parameter B = 1;

// Next state logic
always @(state or in) begin
    case (state)
        A: begin
            if (in == 0)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            if (in == 0)
                next_state = A;
            else
                next_state = B;
        end
        default: next_state = B;  // Default next state
    endcase
end

// Output logic
always @(state) begin
    case (state)
        A: out = 0;
        B: out = 1;
        default: out = 1;  // Default output
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = B;  // Asynchronous reset
    end else begin
        state = next_state;  // Synchronous state update
    end
end

endmodule