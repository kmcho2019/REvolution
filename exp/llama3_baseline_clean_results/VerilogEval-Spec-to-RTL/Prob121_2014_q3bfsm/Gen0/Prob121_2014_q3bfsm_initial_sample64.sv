module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define states as an enumeration
enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100
} state, nextState;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        S000: nextState = (x == 0) ? S000 : S001;
        S001: nextState = (x == 0) ? S001 : S100;
        S010: nextState = (x == 0) ? S010 : S001;
        S011: nextState = (x == 0) ? S001 : S010;
        S100: nextState = (x == 0) ? S011 : S100;
        default: nextState = S000; // This should never be reached
    endcase

    // Determine the output z based on the current state
    case (state)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0; // This should never be reached
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S000;
    end else begin
        state <= nextState;
    end
end

endmodule