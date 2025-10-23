module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] prev_data;  // Stores previous two samples
wire pulse_detected = (prev_data == 2'b10) && (data_in == 1'b0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new data
        prev_data <= {prev_data[0], data_in};
        
        // Registered output for clean timing
        data_out <= pulse_detected;
    end
end

endmodule