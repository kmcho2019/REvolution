module clkgenerator #(parameter integer PERIOD = 10) (
    input wire clk_in,
    output reg clk
);

    // Counter to count input clock cycles
    integer count;

    initial begin
        clk = 0;
        count = 0;
    end

    always @(posedge clk_in) begin
        if (count == (PERIOD/2 - 1)) begin
            clk <= ~clk;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule