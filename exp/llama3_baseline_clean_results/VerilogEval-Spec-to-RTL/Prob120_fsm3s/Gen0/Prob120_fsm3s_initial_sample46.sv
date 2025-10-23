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

// Sequential logic to update state
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine next state
always_comb begin
    case(state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Output logic (Moore machine output depends only on state)
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule