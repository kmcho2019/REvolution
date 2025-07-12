module TopModule (
    input clk,
    input in,
    output reg out
);

    // T flip-flop implementation
    always @(posedge clk) begin
        if (in) begin
            out <= ~out;
        end
    end

endmodule