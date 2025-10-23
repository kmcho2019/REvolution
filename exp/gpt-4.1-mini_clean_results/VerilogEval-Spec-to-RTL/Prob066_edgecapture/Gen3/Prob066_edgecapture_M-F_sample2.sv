module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output reg [31:0]  out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out     <= 32'b0;
        end else begin
            // Detect 1->0 transitions
            wire [31:0] transitions = prev_in & ~in;

            // Update out only if new transitions are detected to avoid unnecessary toggling
            if (transitions != 0)
                out <= out | transitions;
            else
                out <= out;  // hold current value

            prev_in <= in;
        end
    end

endmodule