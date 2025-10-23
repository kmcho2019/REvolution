module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    wire all_zero;

    assign all_zero = ~|shift_reg;
    assign tc = all_zero;

    always @(posedge clk) begin
        if (load) begin
            // Parallel load input data into shift register
            shift_reg <= data;
        end else if (!all_zero) begin
            // Shift right by 1, inserting zero at MSB to approximate countdown
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
        // else: hold zero state
    end

endmodule