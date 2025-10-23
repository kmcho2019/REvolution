module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;

reg [1:0] state, next_state;

// Moore state machine implementation
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @* begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A; // Default to state A for any other state
    endcase
end

// Output logic
always @* begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0 for any other state
    endcase
end

endmodule