module clkgenerator #(
    parameter PERIOD = 10
)(
    input wire clk_base,    // Base clock input
    input wire reset_n,     // Active-low reset
    output reg clk          // Generated clock output (renamed from clk_out)
);

    reg [31:0] counter;

    always @(posedge clk_base or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 1'b0;
        end
        else begin
            if (counter == (PERIOD/2 - 1)) begin
                clk <= ~clk;
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule