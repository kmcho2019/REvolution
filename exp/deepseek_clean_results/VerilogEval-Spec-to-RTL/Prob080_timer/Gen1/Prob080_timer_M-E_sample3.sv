module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [1023:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= (1024'b1 << data);  // Place '1' at data position
        end else if (!tc) begin
            shift_reg <= {1'b0, shift_reg[1023:1]};  // Right shift
        end
    end

    assign tc = shift_reg[0];  // '1' reached LSB

endmodule