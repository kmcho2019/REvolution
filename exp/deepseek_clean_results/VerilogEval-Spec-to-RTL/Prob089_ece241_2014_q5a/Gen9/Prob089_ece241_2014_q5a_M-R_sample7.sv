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
    wire next_state;
    
    // Combinational next state logic
    assign next_state = (state == STATE_COPY) ? (x ? STATE_INVERT : STATE_COPY) : STATE_INVERT;
    
    // Combinational output logic
    assign z = (state == STATE_COPY) ? x : ~x;
    
    // Sequential state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_COPY;
        end else begin
            state <= next_state;
        end
    end

endmodule