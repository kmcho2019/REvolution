module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire enable;

    assign enable = (counter != 0) && (~load);
    assign next_counter = load ? data :
                          (enable ? counter - 1 : counter);

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule