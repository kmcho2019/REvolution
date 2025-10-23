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

    // State transition and register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_COPY;
        end else begin
            case (state)
                STATE_COPY:   state <= x ? STATE_INVERT : STATE_COPY;
                STATE_INVERT: state <= STATE_INVERT;
            endcase
        end
    end

endmodule