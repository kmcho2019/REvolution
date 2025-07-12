module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// One-hot encoding for states A and B
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset to state A
        state <= 2'b01;
    end else begin
        case(state)
            2'b01: if(x) state <= 2'b10; // Transition from A to B on x=1
            2'b10: state <= 2'b10; // Stay in B
        endcase
    end
end

// Generate z based on state and x
always @(*) begin
    case(state)
        2'b01: z = x; // In state A, z = x
        2'b10: z = ~x; // In state B, z = ~x
    endcase
end

endmodule