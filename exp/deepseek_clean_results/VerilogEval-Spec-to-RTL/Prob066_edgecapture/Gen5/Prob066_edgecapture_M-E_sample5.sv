module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // 2-bit shift register for each input bit to track current and previous state
    reg [1:0] history [31:0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            // Clear all outputs and history on reset
            for (i = 0; i < 32; i = i + 1) begin
                history[i] <= 2'b00;
                out[i] <= 1'b0;
            end
        end
        else begin
            for (i = 0; i < 32; i = i + 1) begin
                // Shift in current bit value
                history[i] <= {history[i][0], in[i]};
                
                // Detect falling edge (1->0 transition)
                if (history[i] == 2'b10) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end

endmodule