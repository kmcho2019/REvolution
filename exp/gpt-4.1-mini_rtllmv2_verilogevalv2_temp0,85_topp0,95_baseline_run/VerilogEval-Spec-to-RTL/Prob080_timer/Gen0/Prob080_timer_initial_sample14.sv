module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] counter;

    // Terminal count is asserted when counter is zero
    assign tc = (counter == 10'd0);

    always @(posedge clk) begin
        if (load) begin
            // Load the counter with input data
            counter <= data;
        end else if (counter != 10'd0) begin
            // Decrement the counter if not zero
            counter <= counter - 10'd1;
        end
        // else counter remains zero
    end
endmodule