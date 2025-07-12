module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] prev_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 2'b00;
    end
    else begin
        prev_data <= {prev_data[0], data_in};
    end
end

assign data_out = (prev_data == 2'b10);

endmodule