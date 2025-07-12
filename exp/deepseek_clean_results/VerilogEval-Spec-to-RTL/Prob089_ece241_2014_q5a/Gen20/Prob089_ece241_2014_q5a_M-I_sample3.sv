module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    parameter PASS = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;
    
    // Output is now combinational based on state
    assign z = (state == INVERT) ? ~x : x;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            case (state)
                PASS: state <= x ? INVERT : PASS;
                INVERT: state <= INVERT; // Stay in INVERT state
            endcase
        end
    end

endmodule