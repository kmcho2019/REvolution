module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] y; // Current state

// Combinational logic for next state
always @(*) begin
    case(y)
        3'b000: z = 1'b0; // Output for state 000
        3'b001: z = 1'b0; // Output for state 001
        3'b010: z = 1'b0; // Output for state 010
        3'b011: z = 1'b1; // Output for state 011
        3'b100: z = 1'b1; // Output for state 100
        default: z = 1'bx; // For invalid states, output is undefined
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        y <= 3'b000;
    end else begin
        case(y)
            3'b000: y <= (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: y <= (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: y <= (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: y <= (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: y <= (x == 1'b0) ? 3'b011 : 3'b100;
            default: y <= 3'b000; // For invalid states, reset to 000
        endcase
    end
end

endmodule