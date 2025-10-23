module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states as an enumeration
enum logic [2:0] {A, B, C, D, E, F} current_state, next_state;

// Always block for sequential logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Always block for combinational logic
always @(*) begin
    case (current_state)
        A: next_state = (w == 1'b0) ? B : A;
        B: next_state = (w == 1'b0) ? C : D;
        C: next_state = (w == 1'b0) ? E : D;
        D: next_state = (w == 1'b0) ? F : A;
        E: next_state = (w == 1'b0) ? E : D;
        F: next_state = (w == 1'b0) ? C : D;
    endcase
end

// Assign 'z' output based on the current state
always @(*) begin
    case (current_state)
        A, B, C, D: z = 1'b0;
        E, F: z = 1'b1;
    endcase
end

endmodule