module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] count_reg;
logic [3:0] next_count;

always_latch begin
    if (valid_count) begin
        if (count_reg == 4'd11) begin
            next_count = 4'd0;
        end else begin
            next_count = count_reg + 1;
        end
    end else begin
        next_count = count_reg;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count_reg <= 4'b0000;
    end else begin
        count_reg <= next_count;
    end
end

assign out = count_reg;

endmodule