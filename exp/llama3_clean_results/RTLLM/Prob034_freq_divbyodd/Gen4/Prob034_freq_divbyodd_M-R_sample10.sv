module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor value, default to 5
)(
    input  logic clk,    // Input clock signal
    input  logic rst_n,  // Active low reset signal
    output logic clk_div  // Divided clock output
);

// Validate parameter NUM_DIV to ensure it's an odd number
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("Error: NUM_DIV must be an odd number");
    end
end

logic [2:0] cnt;  // Single counter for clock cycles
logic clk_div_int;  // Internal clock divider

always_ff @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Final divided clock output
assign clk_div = clk_div_int;

endmodule