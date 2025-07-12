module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

reg [1:0] prev_data;
reg [1:0] curr_data;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_data <= 2'b00;
        curr_data <= 2'b00;
    end else begin
        prev_data <= curr_data;
        curr_data <= {curr_data[0], data_in};
    end
end

assign sequence_detected = (curr_data == 2'b01 && prev_data == 2'b10);

endmodule