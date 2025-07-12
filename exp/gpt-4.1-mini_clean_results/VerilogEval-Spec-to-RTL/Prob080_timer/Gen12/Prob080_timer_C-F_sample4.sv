module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_count;

    assign next_count = load ? data :
                        (counter != 10'd0 ? counter - 10'd1 : 10'd0);

    always @(posedge clk) begin
        counter <= next_count;
    end

    assign tc = (counter == 10'd0);

endmodule