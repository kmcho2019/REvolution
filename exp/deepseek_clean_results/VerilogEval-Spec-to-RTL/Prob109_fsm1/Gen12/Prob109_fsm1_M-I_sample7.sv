module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    reg state;  // 0=A, 1=B
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
            out <= 1'b1;    // Output for state B
        end
        else begin
            // Next state and output logic combined
            case (state)
                1'b0: begin // State A
                    state <= in ? 1'b0 : 1'b1;
                    out <= 1'b0;
                end
                1'b1: begin // State B
                    state <= in ? 1'b1 : 1'b0;
                    out <= 1'b1;
                end
            endcase
        end
    end
    
endmodule