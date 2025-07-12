module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire enable_decrement = ~load & (counter != 0);
    wire [9:0] next_counter;

    assign next_counter = load ? data :
                          enable_decrement ? counter - 1 : counter;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule