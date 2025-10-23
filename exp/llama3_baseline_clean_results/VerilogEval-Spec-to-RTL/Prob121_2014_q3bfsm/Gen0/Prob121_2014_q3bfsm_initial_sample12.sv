module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define states
enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100,
    S011_2 = 3'b011
} current_state, next_state;

// Output logic
always_comb begin
    case (current_state)
        S000, S001, S010, S100: z = 1'b0;
        S011, S011_2: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// State transition logic
always_comb begin
    case (current_state)
        S000: next_state = x? S001 : S000;
        S001: next_state = x? S100 : S001;
        S010: next_state = x? S001 : S010;
        S011: next_state = x? S010 : S001;
        S100: next_state = x? S100 : S011;
        default: next_state = S000;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
    end else begin
        current_state <= next_state;
    end
end

endmodule