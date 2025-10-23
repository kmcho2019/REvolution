module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_count;

    // Compute next_count combinationally
    assign next_count = load ? data : (counter != 0 ? counter - 1 : 0);

    // Sequential register update (single always block - single DFF array)
    always @(posedge clk) begin
        counter <= next_count;
    end

    // Terminal count output asserted when counter is zero
    assign tc = (counter == 0);

endmodule