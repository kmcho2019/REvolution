module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Define states
    parameter STATE_COPY = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    
    // Combinational output logic
    assign z = (state == STATE_COPY) ? x : ~x;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_COPY;
        end else begin
            case (state)
                STATE_COPY: begin
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