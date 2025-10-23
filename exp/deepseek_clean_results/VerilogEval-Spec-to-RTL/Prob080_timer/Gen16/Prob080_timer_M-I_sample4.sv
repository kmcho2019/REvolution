module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_enable = load || (|counter);  // Enable counter when loading or counting

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (counter != 10'b0)
            counter <= counter - 1;
    end

    assign tc = (counter == 10'b0);  // Direct comparison for better timing

endmodule