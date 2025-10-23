module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case(state)
        2'b10: z = 1'b0;
        2'b01: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        2'b10: begin
            if (x == 1'b0) begin
                next_state = 2'b10; // Stay in state A
            end else begin
                next_state = 2'b01; // Transition to state B
            end
        end
        2'b01: begin
            next_state = 2'b01; // Stay in state B
        end
        default: next_state = 2'b10; // Default to state A
    endcase
end

endmodule