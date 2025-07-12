module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // One-hot state encoding
    wire idle_state, got1_state, got10_state;
    reg idle_state_reg, got1_state_reg, got10_state_reg;

    // State transition logic (combinational)
    assign idle_state  = (!got1_state_reg && !got10_state_reg) || 
                        (got10_state_reg && !x);
    assign got1_state  = (idle_state_reg && x) || 
                        (got1_state_reg && x);
    assign got10_state = (got1_state_reg && !x);

    // State registers (sequential)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            idle_state_reg  <= 1'b1;
            got1_state_reg  <= 1'b0;
            got10_state_reg <= 1'b0;
        end else begin
            idle_state_reg  <= idle_state;
            got1_state_reg  <= got1_state;
            got10_state_reg <= got10_state;
        end
    end

    // Mealy output depends on current state and input
    assign z = got10_state_reg && x;

endmodule