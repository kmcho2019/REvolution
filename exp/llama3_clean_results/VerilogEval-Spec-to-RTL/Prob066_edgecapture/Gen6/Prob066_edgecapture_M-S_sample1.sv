module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        // Detect transition and update out_reg
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                out_reg[i] <= 1'b1; // Set out_reg bit if transition detected
            end
        end
        
        // Update prev_in for the next cycle
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule