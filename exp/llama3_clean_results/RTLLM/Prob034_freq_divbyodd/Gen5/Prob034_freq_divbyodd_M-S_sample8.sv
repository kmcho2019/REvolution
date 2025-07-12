module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

// Check if NUM_DIV is an odd number
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
    end
end

reg [31:0] cnt;  // Counter
reg prev_clk;  // Previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (prev_clk!= clk) begin  // Edge detection
            cnt <= cnt + 1;
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;  // Toggle divided clock output
            end
        end
        prev_clk <= clk;
    end
end

endmodule