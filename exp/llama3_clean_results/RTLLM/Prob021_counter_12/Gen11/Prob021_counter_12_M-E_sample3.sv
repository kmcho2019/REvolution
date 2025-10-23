module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] counter;

// Sequential logic for the binary counter with clock enable
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'b0000;
    end else if (valid_count) begin
        if (counter == 4'd12) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Output logic to ensure out is always within the range 0 to 11
assign out = (counter < 4'd12)? counter : 4'b0000;

endmodule