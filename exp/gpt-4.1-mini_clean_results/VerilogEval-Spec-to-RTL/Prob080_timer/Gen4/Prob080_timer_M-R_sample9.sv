module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Combinational logic to determine the next counter value
    assign next_counter = load ? data :
                          (|counter ? counter - 10'd1 : 10'd0);

    // Sequential register update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count signal: asserted when counter reaches zero
    assign tc = ~|counter;

endmodule