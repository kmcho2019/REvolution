module clkgenerator
#(parameter PERIOD = 10)
(
    output reg clk,
    input reset
);

reg [31:0] counter;

always @(posedge reset or posedge clk)
begin
    if(reset)
    begin
        counter <= 0;
        clk <= 0;
    end
    else
    begin
        if(counter == (PERIOD / 2))
        begin
            counter <= 0;
            clk <= ~clk;
        end
        else
        begin
            counter <= counter + 1;
        end
    end
end

endmodule