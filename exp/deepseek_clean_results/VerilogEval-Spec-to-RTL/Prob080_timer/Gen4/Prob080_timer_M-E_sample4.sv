module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    // Convert data to thermometer code when loaded
    wire [9:0] thermometer_data;
    assign thermometer_data = {10{1'b1}} >> (10'd10 - data);

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= thermometer_data;
        end else if (|shift_reg) begin
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    assign tc = ~(|shift_reg);

endmodule