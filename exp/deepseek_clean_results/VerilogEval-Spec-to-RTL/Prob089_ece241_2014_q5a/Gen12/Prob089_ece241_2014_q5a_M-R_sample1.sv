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

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end
        else if (state == PASS && x) begin
            state <= INVERT;
        end
    end

    // Mealy output logic
    assign z = (state == PASS) ? x : ~x;

endmodule