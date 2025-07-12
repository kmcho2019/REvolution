module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    reg next_state;
    wire z_comb;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            COPY:    next_state = x ? INVERT : COPY;
            INVERT:  next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Output logic with clock gating
    assign z_comb = (state == COPY) ? x : ~x;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else if (state == COPY || x) begin
            z <= z_comb;
        end
    end

endmodule