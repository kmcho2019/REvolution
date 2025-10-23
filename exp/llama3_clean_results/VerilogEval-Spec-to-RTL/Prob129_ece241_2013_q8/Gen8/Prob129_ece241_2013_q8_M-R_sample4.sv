module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {
    S00,
    S01,
    S10
} state, next_state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= S00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S00: next_state = x ? S01 : S00;
        S01: next_state = x ? S10 : S00;
        S10: next_state = x ? S10 : S01;
    endcase
end

// Output logic
assign z = (state == S10) && x;

endmodule