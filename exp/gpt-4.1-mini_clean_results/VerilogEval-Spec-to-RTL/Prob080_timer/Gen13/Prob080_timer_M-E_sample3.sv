module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) 
            shift_reg <= data;
        else if (shift_reg != 0)
            shift_reg <= {1'b0, shift_reg[9:1]};
        // else keep shift_reg at zero
    end

    assign tc = (shift_reg == 0);

endmodule