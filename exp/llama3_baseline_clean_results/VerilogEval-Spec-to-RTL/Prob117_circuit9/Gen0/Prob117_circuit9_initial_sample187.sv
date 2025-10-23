module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;
assign q = q_reg;

initial q_reg = 3'b000;

always @(posedge clk) begin
    if (a == 1) begin
        if (q_reg == 3'b000) begin
            q_reg <= 3'b100; // Load 4 when a=1 for the first time
        end else begin
            q_reg <= q_reg; // Hold value if a=1 after the first load
        end
    end else begin
        if (q_reg == 3'b110) begin // 6 in decimal
            q_reg <= 3'b000; // Reset to 0 after reaching 6
        end else begin
            q_reg <= q_reg + 1; // Increment for a=0
        end
    end
end

endmodule