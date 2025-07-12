module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

reg [2:0] cnt;  // Counter for clock cycles
reg prev_clk;   // Previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        prev_clk <= clk;
    end
end

assign clk_div = (cnt == (NUM_DIV / 2));

initial begin
    if (NUM_DIV % 2 == 0) begin
        $display("Error: NUM_DIV must be an odd number");
        $finish;
    end
end

endmodule