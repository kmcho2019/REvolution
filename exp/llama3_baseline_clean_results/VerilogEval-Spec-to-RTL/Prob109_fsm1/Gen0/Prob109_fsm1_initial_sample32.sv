module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg out;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 1'b1; // Reset to state B
    end else begin
        case(out)
            1'b0: // State A
                if (in == 1'b1) begin
                    out <= 1'b0; // Stay in A if in=1
                end else begin
                    out <= 1'b1; // Go to B if in=0
                end
            1'b1: // State B
                if (in == 1'b1) begin
                    out <= 1'b1; // Stay in B if in=1
                end else begin
                    out <= 1'b0; // Go to A if in=0
                end
        endcase
    end
end

endmodule