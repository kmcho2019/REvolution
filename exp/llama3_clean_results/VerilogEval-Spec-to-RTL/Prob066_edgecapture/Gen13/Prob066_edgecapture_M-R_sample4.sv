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
        // Non-blocking assignment to update out
        out <= out; // Retain previous state by default
        
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out[i] <= 1'b1; // Update out[i] only when a transition is detected
            end
        end
        prev_in <= in; // Update prev_in after checking for transitions
    end
end

endmodule