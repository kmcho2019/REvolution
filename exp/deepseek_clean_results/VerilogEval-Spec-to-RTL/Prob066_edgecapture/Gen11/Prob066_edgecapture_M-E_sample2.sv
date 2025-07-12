module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // 2-bit history registers for each input bit
    reg [1:0] history [31:0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            // Clear all outputs and history on reset
            out <= 32'b0;
            for (i = 0; i < 32; i = i + 1) begin
                history[i] <= 2'b00;
            end
        end else begin
            for (i = 0; i < 32; i = i + 1) begin
                // Update history (shift left and insert new bit)
                history[i] <= {history[i][0], in[i]};

                // Detect falling edge (pattern "10") and set sticky output
                if (history[i] == 2'b10) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end

endmodule