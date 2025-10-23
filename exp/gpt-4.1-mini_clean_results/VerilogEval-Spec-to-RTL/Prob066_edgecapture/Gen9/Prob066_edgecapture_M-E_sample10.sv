module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            for (i = 0; i < 32; i = i + 1) begin
                // Detect falling edge: prev_in bit 1 and current in bit 0
                if (prev_in[i] && ~in[i])
                    out[i] <= 1'b1;
                // Otherwise retain previous output bit value
                else
                    out[i] <= out[i];
            end
            prev_in <= in;
        end
    end

endmodule