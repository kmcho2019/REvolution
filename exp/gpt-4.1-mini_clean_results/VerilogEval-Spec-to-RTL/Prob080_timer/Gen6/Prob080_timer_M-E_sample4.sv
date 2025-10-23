module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_reg;

// Convert input data to one-hot load value: a '1' at bit position data[3:0]
wire [9:0] load_pattern;
assign load_pattern = (data < 10) ? (10'b1 << data) : 10'b0; 

always @(posedge clk) begin
    if (load) begin
        shift_reg <= load_pattern;
    end else if (shift_reg != 0) begin
        shift_reg <= shift_reg >> 1;
    end else begin
        shift_reg <= 0;
    end
end

assign tc = (shift_reg == 0);

endmodule