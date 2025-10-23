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
    reg next_z;
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end else begin
            case (state)
                STATE_PASS: state <= x ? STATE_INVERT : STATE_PASS;
                STATE_INVERT: state <= STATE_INVERT;
            endcase
        end
    end
    
    // Output generation (combinational)
    always @(*) begin
        case (state)
            STATE_PASS: next_z = x;
            STATE_INVERT: next_z = ~x;
        endcase
    end
    
    // Output registration (pipelined)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            z <= next_z;
        end
    end

endmodule