module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    reg next_state;

    // Combinational output logic
    assign z = (state == COPY) ? x : ~x;

    // Next state logic
    always @(*) begin
        case (state)
            COPY:    next_state = x ? INVERT : COPY;
            INVERT:  next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            state <= next_state;
        end
    end

endmodule