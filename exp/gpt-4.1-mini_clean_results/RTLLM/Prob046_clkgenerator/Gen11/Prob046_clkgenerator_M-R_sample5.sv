module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

initial begin
    clk = 1'b0;
    toggle_clock();
end

task toggle_clock;
    begin
        #(PERIOD / 2);
        clk = ~clk;
        toggle_clock();
    end
endtask

endmodule