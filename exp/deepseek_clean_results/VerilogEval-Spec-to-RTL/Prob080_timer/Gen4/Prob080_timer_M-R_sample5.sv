module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] decremented = counter - 1'b1;
    wire should_decrement = ~load & (counter != 10'b0);

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (should_decrement)
            counter <= decremented;
    end

    assign tc = (counter == 10'b0);

endmodule