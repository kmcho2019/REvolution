module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        out <= out; // retain the previous value of out unless changed
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out[i] <= 1'b1; // set out[i] to 1 when a falling edge is detected
            end
        end
        prev_in <= in;
    end
end

endmodule