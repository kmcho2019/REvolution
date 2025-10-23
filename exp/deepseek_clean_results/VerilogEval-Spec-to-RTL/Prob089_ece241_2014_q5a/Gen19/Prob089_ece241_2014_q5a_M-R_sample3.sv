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
    
    // Output assignment (combinational)
    assign z = (state == PASS) ? x : ~x;
    
    // State transition logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            case (state)
                PASS: if (x) state <= INVERT;
                INVERT: state <= INVERT;  // Stay in INVERT state once entered
            endcase
        end
    end

endmodule