module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with descriptive parameters
    localparam [1:0] STATE_A = 2'b00,
                     STATE_B = 2'b01,
                     STATE_C = 2'b10;
                     // STATE_D not needed per specification

    reg [1:0] current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Optimized state transition logic
    always @(*) begin
        next_state = STATE_A; // Default to STATE_A
        
        case (current_state)
            STATE_A: begin
                if (r[0])        next_state = STATE_B;
                else if (r[1])   next_state = STATE_C;
                // No STATE_D transition as per spec
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            default: next_state = STATE_A; // For robustness
        endcase
    end

    // Minimal output logic - only g[0] and g[1] needed per spec
    assign g[0] = (current_state == STATE_B);
    assign g[1] = (current_state == STATE_C);
    assign g[2] = 1'b0; // Always 0 as per specification

endmodule