module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 10'b0);
    wire gated_clk = clk & (~counter_zero | load);
    
    always @(posedge gated_clk) begin
        if (load)
            counter <= data;
        else if (~counter_zero)
            counter <= counter - 1;
    end

    assign tc = counter_zero;

endmodule