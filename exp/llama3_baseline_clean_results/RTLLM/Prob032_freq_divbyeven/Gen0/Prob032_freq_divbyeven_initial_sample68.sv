module freq_diveven #(
    parameter NUM_DIV = 10 // Default division factor, must be an even number
) (
    input  logic       clk,
    input  logic       rst_n,
    output logic       clk_div
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

// 4-bit register to count clock cycles
logic [3:0] cnt;

// Divided clock output signal
logic       clk_div_q; // Internal signal to avoid latching

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt    <= 4'd0; // Reset counter
        clk_div_q <= 1'b0; // Reset divided clock output
    end else begin
        if (cnt == (NUM_DIV / 2 - 1)) begin // Reached half of the division factor
            cnt    <= 4'd0; // Reset counter
            clk_div_q <= ~clk_div_q; // Toggle divided clock output
        end else begin
            cnt    <= cnt + 4'd1; // Increment counter
        end
    end
end

// Continuous assignment for output
assign clk_div = clk_div_q;

endmodule