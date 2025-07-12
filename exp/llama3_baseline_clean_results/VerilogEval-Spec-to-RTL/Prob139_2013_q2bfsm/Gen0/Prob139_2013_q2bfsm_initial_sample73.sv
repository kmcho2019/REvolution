module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

typedef enum logic [3:0] {
    A,  // initial state
    B,  // set f = 1
    C,  // monitor x
    D,  // set g = 1 and monitor y
    E,  // maintain g = 1
    F   // maintain g = 0
} state_type;

state_type state, next_state;

reg [2:0] x_seq;  // sequence of x inputs
reg [1:0] y_count;  // count of clock cycles since g = 1

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        x_seq <= {x, x_seq[1:0]};
        y_count <= (state == D) ? y_count + 1 : 0;
        f <= (state == B) ? 1 : 0;
        g <= (state == D || state == E) ? 1 : 0;
    end
end

always @* begin
    case (state)
        A: next_state = (resetn) ? B : A;
        B: next_state = C;
        C: next_state = (x_seq == 5'b101) ? D : C;
        D: next_state = (y || (y_count == 2)) ? (y) ? E : F : D;
        E: next_state = E;
        F: next_state = F;
        default: next_state = A;
    endcase
end

endmodule