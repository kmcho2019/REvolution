module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;

initial if (NUM_DIV < 2 || NUM_DIV%2 != 0) begin
    $error("NUM_DIV must be even and >= 2");
    $finish;
end

reg [$clog2(NUM_DIV/2)-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else if (cnt == (NUM_DIV/2)-1) begin
        cnt <= 0;
        clk_div <= ~clk_div;
    end
    else begin
        cnt <= cnt + 1;
    end
end

endmodule