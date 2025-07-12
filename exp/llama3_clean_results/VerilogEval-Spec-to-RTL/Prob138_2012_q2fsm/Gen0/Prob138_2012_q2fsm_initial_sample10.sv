module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Output logic
always @(*) begin
    case (current_state)
        4: z = 1; // State E
        5: z = 1; // State F
        default: z = 0;
    endcase
end

// Next state logic
always @(*) begin
    case (current_state)
        0: next_state = (w) ? 1 : 0; // State A
        1: next_state = (w) ? 2 : 3; // State B
        2: next_state = (w) ? 4 : 3; // State C
        3: next_state = (w) ? 5 : 0; // State D
        4: next_state = (w) ? 4 : 3; // State E
        5: next_state = (w) ? 2 : 3; // State F
        default: next_state = 0;
    endcase
end

// Current state flip-flops
always @(posedge clk) begin
    if (reset) begin
        current_state <= 0; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule