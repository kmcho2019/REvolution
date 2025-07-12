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
        out <= out; // Maintain current state unless changed
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] &&!in[i]) begin
                out[i] <= 1'b1; // Set the bit high if a transition from 1 to 0 is detected
            end
        end
        prev_in <= in; // Update prev_in with the current value of in
    end
end

endmodule