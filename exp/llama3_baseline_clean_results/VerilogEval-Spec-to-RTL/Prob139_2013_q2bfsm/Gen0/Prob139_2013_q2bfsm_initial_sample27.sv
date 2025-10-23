module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
enum logic [2:0] {
    A,  // initial state, reset
    B,  // set f to 1 for one clock cycle
    C,  // monitor x input
    D,  // monitor y input
    E,  // g = 1 permanently
    F   // g = 0 permanently
} state, next_state;

// internal signals
logic [1:0] x_count;
logic [1:0] y_count;

// output assignments
assign f = (state == B) ? 1'b1 : 1'b0;
assign g = (state == E) ? 1'b1 : (state == F) ? 1'b0 : (state == D) ? 1'b1 : 1'b0;

// sequential logic
always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_count <= 2'b00;
        y_count <= 2'b00;
    end else begin
        state <= next_state;
        x_count <= (state == C) ? (x == 1'b1 && x_count == 2'b11) ? 2'b00 : (x == 1'b1) ? x_count + 1 : x_count : 2'b00;
        y_count <= (state == D) ? y_count + 1 : 2'b00;
    end
end

// combinational logic
always_comb begin
    next_state = state;
    case (state)
        A: if (resetn) next_state = B;
        B: next_state = C;
        C: if (x_count == 2'b11) next_state = D;
        D: if (y == 1'b1 || y_count == 2'b10) next_state = (y == 1'b1) ? E : F;
        E, F: next_state = state;
        default: next_state = A;
    endcase
end

endmodule