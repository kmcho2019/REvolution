module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] count;
logic reset_count;

assign reset_count = (count == 4'd11)? 1'b1 : 1'b0;

always_comb begin
    if (reset_count) begin
        out = 4'b0000;
    end else begin
        out = count;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000;
    end else if (valid_count) begin
        if (reset_count) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule