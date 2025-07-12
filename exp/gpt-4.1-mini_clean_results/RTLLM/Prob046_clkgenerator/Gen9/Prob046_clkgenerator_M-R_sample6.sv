module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

initial begin
    clk = 1'b0;
    toggle_clk();
end

// Recursive task to toggle clk every half PERIOD indefinitely
task automatic toggle_clk;
begin
    #(PERIOD / 2);
    clk = ~clk;
    toggle_clk();
end
endtask

endmodule