module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    // Priority encoder to find the position to set the '1' when loading
    wire [9:0] load_pattern;
    assign load_pattern = (10'b1 << data);

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= load_pattern;
        end else if (!tc) begin
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    assign tc = (shift_reg == 10'b0000000001);

endmodule