module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11} current_state, next_state;

// Combinational logic to determine next state
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Moore machine output
assign out = (current_state == D) ? 1'b1 : 1'b0;

endmodule