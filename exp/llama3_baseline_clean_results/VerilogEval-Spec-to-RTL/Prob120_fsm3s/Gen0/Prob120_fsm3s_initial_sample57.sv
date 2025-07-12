module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} state, next_state;

// Output logic based on current state
always_comb begin
    case(state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case(state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
        endcase
    end
end

endmodule