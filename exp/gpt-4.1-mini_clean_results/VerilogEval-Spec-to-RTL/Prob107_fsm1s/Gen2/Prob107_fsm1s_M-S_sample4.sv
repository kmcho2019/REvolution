module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // B state
            out <= 1'b1;
        end else begin
            if (state == 1'b0) begin
                out <= 1'b1;         // B state output
                state <= (in == 1'b0) ? 1'b1 : 1'b0;
            end else begin
                out <= 1'b0;         // A state output
                state <= (in == 1'b0) ? 1'b0 : 1'b1;
            end
        end
    end

endmodule