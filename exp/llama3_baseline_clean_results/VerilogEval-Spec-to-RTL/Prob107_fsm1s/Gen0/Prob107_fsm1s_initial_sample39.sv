module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] current_state; // Using 1-bit to represent two states
reg [0:0] next_state;

parameter A = 1'b0;
parameter B = 1'b1;

always @(*) begin
    case (current_state)
        A: next_state = (in) ? A : B;
        B: next_state = (in) ? B : A;
        default: next_state = B; // Reset state
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

assign out = (current_state == B) ? 1'b1 : 1'b0;

initial begin
    current_state = B;
end

endmodule