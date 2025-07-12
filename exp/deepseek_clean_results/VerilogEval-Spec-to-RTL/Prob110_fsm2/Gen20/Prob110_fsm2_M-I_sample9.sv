module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    // Combined state and output register (Moore machine)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // Reset to OFF state
        end
        else begin
            case (out)
                1'b0: out <= j;  // OFF state: transition to ON if j=1
                1'b1: out <= ~k; // ON state: stay if k=0, transition to OFF if k=1
            endcase
        end
    end
endmodule