module clkgenerator #(
    parameter PERIOD = 10,
    parameter COUNTER_WIDTH = $clog2(PERIOD)
) (
    output reg clk,
    input reset_n
);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 1'b0;
        end
        else begin
            if (counter >= (PERIOD/2 - 1)) begin
                counter <= 0;
                clk <= ~clk;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

    // Initial clock generation (for simulation)
    initial begin
        clk = 1'b0;
        counter = 0;
        if (PERIOD % 2 != 0) begin
            $display("Warning: PERIOD should be even for 50% duty cycle");
        end
    end
endmodule