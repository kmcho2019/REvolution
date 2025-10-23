module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [1023:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            // Initialize with 'data' number of 1's
            shift_reg <= (1 << data) - 1;
        end else begin
            // Right shift with 0 fill
            shift_reg <= {1'b0, shift_reg[1023:1]};
        end
    end

    assign tc = shift_reg[0];

endmodule