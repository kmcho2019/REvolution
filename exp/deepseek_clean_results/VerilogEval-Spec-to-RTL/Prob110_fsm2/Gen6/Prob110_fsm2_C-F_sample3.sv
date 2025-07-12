module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State definitions
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg state;  // Current state register
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;  // Async reset to OFF
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end
    
    // Output assignment (Moore machine)
    assign out = state;
    
endmodule