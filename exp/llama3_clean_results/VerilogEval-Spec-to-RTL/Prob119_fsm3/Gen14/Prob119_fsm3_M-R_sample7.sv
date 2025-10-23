module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as an enumeration
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// State register
reg state_t state;

// Output logic
always @(*) begin
    case(state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
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