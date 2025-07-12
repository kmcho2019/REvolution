module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // State encoding
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    reg next_state;
    reg j_reg, k_reg;
    reg inputs_changed;
    
    // Clock gating control
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            j_reg <= 1'b0;
            k_reg <= 1'b0;
            inputs_changed <= 1'b1;
        end else begin
            j_reg <= j;
            k_reg <= k;
            inputs_changed <= (j != j_reg) || (k != k_reg);
        end
    end
    
    // Next state logic using case statement
    always @(*) begin
        case (state)
            OFF: next_state = j_reg ? ON : OFF;
            ON:  next_state = k_reg ? OFF : ON;
            default: next_state = OFF;
        endcase
    end
    
    // State register update with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else if (inputs_changed) begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign out = (state == ON);
endmodule