module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using 1-bit to represent two states (A=0, B=1)
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset into state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b1: // State B
            if (in) begin
                next_state = 1'b1; // B (1) --1--> B
            end else begin
                next_state = 1'b0; // B (1) --0--> A
            end
        1'b0: // State A
            if (in) begin
                next_state = 1'b0; // A (0) --1--> A
            end else begin
                next_state = 1'b1; // A (0) --0--> B
            end
    endcase
end

assign out = state; // Output determined solely by current state

endmodule