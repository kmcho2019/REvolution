module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    // Define states with clear parameter names
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;
    
    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
            endcase
        end
    end
    
    // Direct state assignment for output (more efficient than comparison)
    assign out = state;
endmodule