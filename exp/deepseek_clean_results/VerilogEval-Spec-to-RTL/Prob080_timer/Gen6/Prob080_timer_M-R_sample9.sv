module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Next counter value calculation
    assign next_counter = load ? data : 
                        (counter != 0) ? (counter - 1) : counter;

    // Sequential logic (single DFF)
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = (counter == 0);

endmodule