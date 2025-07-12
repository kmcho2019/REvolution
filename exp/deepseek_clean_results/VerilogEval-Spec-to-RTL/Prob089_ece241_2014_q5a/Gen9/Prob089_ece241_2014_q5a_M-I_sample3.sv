module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    
    // Combined sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
            z <= 1'b0;
        end else begin
            case (state)
                STATE_PASS: begin
                    state <= x ? STATE_INVERT : STATE_PASS;
                    z <= x;
                end
                STATE_INVERT: begin
                    state <= STATE_INVERT;
                    z <= ~x;
                end
            endcase
        end
    end

endmodule