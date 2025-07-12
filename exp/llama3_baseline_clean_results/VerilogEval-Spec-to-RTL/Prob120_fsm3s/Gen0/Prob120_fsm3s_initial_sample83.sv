module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Assign output based on state
always_comb begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// State machine logic
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