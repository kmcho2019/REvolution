module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Compute next counter value combinationally
    assign next_counter = load ? data :
                          (counter != 0) ? (counter - 1) :
                          10'd0;

    // Update counter at positive clock edge
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count when counter reaches zero
    assign tc = (counter == 0);

endmodule