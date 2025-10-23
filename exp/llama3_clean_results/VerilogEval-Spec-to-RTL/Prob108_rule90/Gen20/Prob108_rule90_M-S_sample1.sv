module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            assign left = (i == 0) ? 1'b0 : q_reg[i - 1];
            assign center = q_reg[i];
            assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
            
            // Apply Rule 90 logic directly
            next_state[i] = left ^ right;
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule