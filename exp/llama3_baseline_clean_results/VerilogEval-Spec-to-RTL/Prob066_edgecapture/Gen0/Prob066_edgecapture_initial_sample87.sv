module TopModule(
    input               clk,
    input               reset,
    input       [31:0]  in,
    output reg  [31:0]  out
);

reg [31:0] prev_in;

always @ (posedge clk) begin
    if (reset) begin
        out <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (~prev_in[i] && in[i]) begin
                // do nothing, because we are looking for 1 to 0 transitions
            end else if (prev_in[i] && ~in[i]) begin
                out[i] <= 1'b1;
            end
        end
    end
end

endmodule