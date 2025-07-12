module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Compute next counter value: load data if load asserted,
    // else decrement counter if not zero, else hold zero.
    assign next_counter = load ? data :
                          (counter != 10'd0 ? counter - 10'd1 : 10'd0);

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 10'd0);

endmodule