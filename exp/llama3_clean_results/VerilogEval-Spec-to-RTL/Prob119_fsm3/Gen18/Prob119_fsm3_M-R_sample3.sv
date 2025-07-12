module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states using binary encoding
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Sequential logic for state transition and output logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic using continuous assignment
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule