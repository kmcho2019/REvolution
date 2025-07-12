module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

// Enum for states
enum logic [2:0] {
    S000,
    S001,
    S010,
    S011,
    S100
} current_state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        S000: next_state = (x == 0) ? S000 : S001;
        S001: next_state = (x == 0) ? S001 : S100;
        S010: next_state = (x == 0) ? S010 : S001;
        S011: next_state = (x == 0) ? S001 : S010;
        S100: next_state = (x == 0) ? S011 : S100;
        default: next_state = S000;
    endcase
    
    case (current_state)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0;
    endcase
end

endmodule