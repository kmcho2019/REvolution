module freq_diveven (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

parameter NUM_DIV = 4; // Division factor, must be an even number

reg [3:0] cnt; // 4-bit counter
reg       clk_div; // Divided clock output signal

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

// Counter and divided clock signal logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
            clk_div <= clk_div;
        end else begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule