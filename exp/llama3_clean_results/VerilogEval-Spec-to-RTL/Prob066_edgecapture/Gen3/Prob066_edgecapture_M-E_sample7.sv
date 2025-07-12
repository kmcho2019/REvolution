module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] transition_history;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
        transition_history <= 32'd0;
    end else begin
        prev_in <= in;
        
        // Detect transitions from 1 to 0
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] &&!in[i]) begin
                transition_history[i] <= 1'b1;
            end
        end
        
        // Update out based on transition_history
        out <= transition_history;
    end
end

endmodule