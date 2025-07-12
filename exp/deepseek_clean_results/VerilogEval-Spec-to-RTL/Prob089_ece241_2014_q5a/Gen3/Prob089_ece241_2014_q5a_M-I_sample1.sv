module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding
    localparam BEFORE_FIRST_1 = 1'b0;
    localparam AFTER_FIRST_1  = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_FIRST_1;
        end
        else begin
            case (state)
                BEFORE_FIRST_1: 
                    if (x) state <= AFTER_FIRST_1;
                AFTER_FIRST_1: 
                    state <= AFTER_FIRST_1; // Stay in this state
            endcase
        end
    end
    
    // Output is purely combinational
    assign z = (state == AFTER_FIRST_1) ? ~x : x;

endmodule