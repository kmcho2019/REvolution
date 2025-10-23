module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire enable;

    assign next_counter = load ? data :
                          (counter != 0 ? counter - 1 : 0);

    assign enable = load | (counter != 0);

    always @(posedge clk) begin
        if (enable) 
            counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule