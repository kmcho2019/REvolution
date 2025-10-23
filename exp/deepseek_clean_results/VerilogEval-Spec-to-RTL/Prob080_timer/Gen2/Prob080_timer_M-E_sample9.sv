module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            // Position the '1' at the appropriate bit
            shift_reg <= (10'b1 << data);
        end else begin
            // Shift right when not loading
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    // tc is asserted when the '1' reaches the LSB
    assign tc = shift_reg[0];

endmodule