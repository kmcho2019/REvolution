module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Calculate next counter value
    assign next_counter = load ? data : 
                        (counter != 10'b0) ? (counter - 1'b1) : 
                        counter;

    // Counter register
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = (counter == 10'b0);

endmodule