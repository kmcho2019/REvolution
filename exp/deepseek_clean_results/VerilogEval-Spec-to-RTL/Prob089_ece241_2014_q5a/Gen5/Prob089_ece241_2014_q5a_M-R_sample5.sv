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
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_COPY;
        end else begin
            case (state)
                STATE_COPY: if (x) state <= STATE_INVERT;
                STATE_INVERT: state <= STATE_INVERT; // Stay in this state
            endcase
        end
    end
    
    // Output logic - purely combinational
    assign z = (state == STATE_COPY) ? x : ~x;

endmodule