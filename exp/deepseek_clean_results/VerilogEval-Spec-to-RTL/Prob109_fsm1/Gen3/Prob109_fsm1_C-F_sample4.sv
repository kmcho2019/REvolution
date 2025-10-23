module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions with localparam
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    // State registers
    reg state;
    wire next_state;
    
    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
            default: next_state = B; // Safe default
        endcase
    end
    
    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Async reset to state B
        end else begin
            state <= next_state;
        end
    end
    
    // Output assignment (Moore machine)
    assign out = state;
    
endmodule