module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire enable;

    assign enable = ~load & (counter != 0);

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (enable)
            counter <= counter - 1;
        else
            counter <= counter; // Hold value when not enabled
    end

    assign tc = (counter == 0);

endmodule