module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] shift_reg;
reg load_en;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;  // Synchronous reset
        load_en <= 1'b1;    // Prepare to load new data
    end else begin
        if (load_en) begin
            // Parallel load new data
            shift_reg <= d;
            load_en <= 1'b0;
        end else begin
            // Circular shift operation
            shift_reg <= {shift_reg[0], shift_reg[7:1]};
        end
    end
end

// Output the current register value
always @(*) begin
    q = shift_reg;
end

endmodule