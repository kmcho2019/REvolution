module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Output z is determined by current state and input x
always @(*) begin
    case (state)
        2'b01: z = ~x; // State A
        2'b10: z = x;  // State B
        default: z = 1'b0; // Default, should not occur in normal operation
    endcase
end

// State transitions
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (~x) begin
                next_state = 2'b01; // Stay in A if x is 0
            end else begin
                next_state = 2'b10; // Go to B if x is 1
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B regardless of x
        end
        default: next_state = 2'b01; // Should not occur, default to A
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule