module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Define states
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    
    // Combinational output logic
    assign z = (state == STATE_PASS) ? x : ~x;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end
        else begin
            case (state)
                STATE_PASS: begin
                    if (x) begin
                        state <= STATE_INVERT;
                    end
                end
                STATE_INVERT: begin
                    // Stay in this state
                end
            endcase
        end
    end

endmodule