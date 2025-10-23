module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states as enum values
enum logic [1:0] {A, B, C, D} state, next_state;

// Assign output based on current state
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
        endcase
    end
end

endmodule