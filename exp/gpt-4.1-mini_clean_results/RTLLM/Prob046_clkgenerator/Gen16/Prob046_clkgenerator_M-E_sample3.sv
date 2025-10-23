module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Internal time counter
    reg [31:0] counter;

    initial begin
        clk = 1'b0;
        counter = 0;
    end

    always @(*) begin
        // empty combinational for simulation completeness
    end

    // Advance time counter every 1 time unit, toggle clk every PERIOD/2
    always begin
        #1; // 1 time unit delay
        counter = counter + 1;
        if (counter >= (PERIOD/2)) begin
            counter = 0;
            clk = ~clk;
        end
    end

endmodule