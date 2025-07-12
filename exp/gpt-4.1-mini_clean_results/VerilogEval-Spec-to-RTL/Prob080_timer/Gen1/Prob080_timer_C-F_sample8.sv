module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            // Load the counter with the input data when load is high
            counter <= data;
        end else if (counter != 10'd0) begin
            // Decrement the counter by 1 when not zero and load is low
            counter <= counter - 10'd1;
        end
        // else hold zero (counter remains zero once reached)
    end

    // Terminal count output asserted when counter is zero
    assign tc = (counter == 10'd0);

endmodule