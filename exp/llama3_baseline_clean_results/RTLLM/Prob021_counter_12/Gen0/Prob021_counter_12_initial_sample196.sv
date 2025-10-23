module counter_12 (
    input   logic       rst_n,  // Reset signal (active low)
    input   logic       clk,   // Clock signal
    input   logic       valid_count,  // Signal to enable counting
    output  logic [3:0]  out    // 4-bit output representing the current count value
);

// Declare the output register
reg [3:0] out_reg;

// Continuous assignment to output port
assign out = out_reg;

// Sequential logic block
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        out_reg <= 4'b0000;
    end else if (valid_count) begin
        // Increment or wrap around condition
        if (out_reg == 4'd11) begin
            out_reg <= 4'b0000;
        end else begin
            out_reg <= out_reg + 1;
        end
    end else begin
        // Do nothing, keep the current value if not counting
        out_reg <= out_reg;
    end
end

endmodule