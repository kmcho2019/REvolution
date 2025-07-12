module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states
parameter S000 = 3'b000,
          S001 = 3'b001,
          S010 = 3'b010,
          S011 = 3'b011,
          S100 = 3'b100;

reg [2:0] current_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
    end else begin
        case (current_state)
            S000: current_state <= (x == 0) ? S000 : S001;
            S001: current_state <= (x == 0) ? S001 : S100;
            S010: current_state <= (x == 0) ? S010 : S001;
            S011: current_state <= (x == 0) ? S001 : S010;
            S100: current_state <= (x == 0) ? S011 : S100;
            default: current_state <= S000; // Default to initial state for any other state
        endcase
    end
end

always @(*) begin
    case (current_state)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0; // Default output for any other state
    endcase
end

endmodule