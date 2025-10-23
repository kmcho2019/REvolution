module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;

// Sequential logic with combinational logic inside
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        case (out)
            4'd11: out <= 4'b0000;
            default: out <= out + 1;
        endcase
    end else begin
        // No action if valid_count is 0, out remains unchanged
    end
end

endmodule