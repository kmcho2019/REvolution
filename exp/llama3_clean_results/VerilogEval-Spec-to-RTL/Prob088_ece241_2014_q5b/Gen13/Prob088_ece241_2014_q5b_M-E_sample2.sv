module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Gray code encoding for states A (00) and B (01)
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if(areset) state <= 2'b00; // Reset to state A
    else if (!x && state == 2'b00) state <= 2'b00; // Stay in A if x=0
    else if (x && state == 2'b00) state <= 2'b01; // Transition to B if x=1
    else if (!x && state == 2'b01) state <= 2'b01; // Stay in B if x=0
    else if (x && state == 2'b01) state <= 2'b01; // Stay in B if x=1
end

always @(*) begin
    case(state)
        2'b00: z = 1'b0; // In state A, z=0
        2'b01: z = 1'b1; // In state B, z=1
        default: z = 1'bx; // Invalid state, set z to unknown
    endcase
end

endmodule