module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire any_bit_set;

    // Parallel OR to detect any set bit
    assign any_bit_set = |counter;
    assign tc = ~any_bit_set;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (any_bit_set) begin
            // Shift right (equivalent to count down)
            // The LSB naturally falls off when shifting right
            counter <= {1'b0, counter[9:1]};
        end
    end

endmodule