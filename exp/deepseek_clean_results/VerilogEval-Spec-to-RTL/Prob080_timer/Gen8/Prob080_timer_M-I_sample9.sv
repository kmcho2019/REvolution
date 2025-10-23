module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire clk_en = !tc || load;
    wire gated_clk = clk & clk_en;

    always @(posedge gated_clk) begin
        if (load) begin
            counter <= data;
            tc <= 0;
        end
        else if (!tc) begin
            counter <= counter - 1;
            tc <= (counter == 1);
        end
    end

endmodule