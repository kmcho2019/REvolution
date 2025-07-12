module freq_divbyodd (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5; // Default odd divisor value

// Check if NUM_DIV is odd
generate
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
    end
endgenerate

localparam WIDTH = $clog2(NUM_DIV * 2); // Counter width

reg [WIDTH - 1:0] cnt; // Counter
reg clk_div_int; // Internal clock divider output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active low reset
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == NUM_DIV - 1) begin // Toggle clk_div_int at every NUM_DIV clock cycles
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

always @ (*) begin
    clk_div = clk_div_int; // Derive final divided clock output
end

endmodule