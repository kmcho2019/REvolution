module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] currentState, nextState;

// Output logic (continuous assignment)
assign g[0] = (currentState == 2'b01); // B state
assign g[1] = (currentState == 2'b10); // C state
assign g[2] = 1'b0; // Since D's behavior isn't explicitly defined in terms of output

// Next state logic
always @(*) begin
    case(currentState)
        2'b00: // A
            if(r[0])
                nextState = 2'b01; // B
            else if(r[1])
                nextState = 2'b10; // C
            else if(r[2])
                nextState = 2'b00; // Treat as A for simplicity
            else
                nextState = 2'b00; // Stay in A
        2'b01: // B
            if(r[0])
                nextState = 2'b01; // Stay in B
            else
                nextState = 2'b00; // Go back to A
        2'b10: // C
            if(r[1])
                nextState = 2'b10; // Stay in C
            else
                nextState = 2'b00; // Go back to A
        default: // For 2'b11 (D), treat similarly to A for simplicity
            if(r[0])
                nextState = 2'b01; // B
            else if(r[1])
                nextState = 2'b10; // C
            else if(r[2])
                nextState = 2'b00; // Stay as A
            else
                nextState = 2'b00; // Stay in A
    endcase
end

// State flip-flop logic
always @(posedge clk) begin
    if(!resetn) begin
        currentState <= 2'b00; // Reset to A
    end else begin
        currentState <= nextState;
    end
end

endmodule