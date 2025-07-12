module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_register;
assign tc = (shift_register == 10'd0);

always @(posedge clk)
    if (load) begin
        // Load pattern of ones into shift register based on data
        shift_register <= {data, {10-{data}-1{1'b0}}};
    end else if (shift_register != 10'd0) begin
        // Shift right to move towards terminal condition
        shift_register <= shift_register >> 1;
    end

endmodule