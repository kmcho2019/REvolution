module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_enable = (counter != 0) && !load;
    wire gated_clk = clk & counter_enable;

    always @(posedge gated_clk or posedge clk) begin
        if (clk) begin
            if (load) begin
                counter <= data;
            end else if (counter_enable) begin
                counter <= counter - 1;
            end
        end
    end

    always @(posedge clk) begin
        tc <= (counter == 0);
    end

endmodule