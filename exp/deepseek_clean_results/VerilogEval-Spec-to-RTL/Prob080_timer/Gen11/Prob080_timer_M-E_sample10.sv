module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    
    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else begin
            // Natural saturation at zero due to arithmetic properties
            counter <= {1'b0, counter[9:1]} ? (counter - 1) : 0;
        end
    end

    // Terminal count is simply when MSB is zero (for this encoding)
    assign tc = ~counter[9];

endmodule