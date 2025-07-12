module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    wire [9:0] load_value;
    wire zero_load = (data == 0);

    // Create a one-hot load pattern with a '1' at (data-1) position if data > 0
    assign load_value = zero_load ? 10'b0 : (10'b1 << (data - 1));

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= load_value;
        end else begin
            // Shift right by one, zero fills left; stay at zero once fully shifted out
            if (shift_reg != 0)
                shift_reg <= shift_reg >> 1;
            else
                shift_reg <= 0;
        end
    end

    assign tc = (shift_reg == 0);

endmodule