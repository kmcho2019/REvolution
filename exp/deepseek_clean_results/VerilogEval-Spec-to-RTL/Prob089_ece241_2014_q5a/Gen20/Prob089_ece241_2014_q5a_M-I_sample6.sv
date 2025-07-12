module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    parameter PASS = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
            z <= 1'b0;
        end else begin
            // Combined state transition and output logic
            state <= state ? INVERT : x;
            z <= state ? ~x : x;
        end
    end

endmodule