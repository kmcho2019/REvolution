module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_counter;

    always @(posedge clk) begin
        if (load) begin
            shift_counter <= data;
        end else if (!(&shift_counter)) begin  // Not all 1's (not zero)
            shift_counter <= {1'b1, shift_counter[9:1]};  // Shift right with 1 fill
        end
    end

    assign tc = shift_counter[0];  // Terminal count when LSB is 1

endmodule