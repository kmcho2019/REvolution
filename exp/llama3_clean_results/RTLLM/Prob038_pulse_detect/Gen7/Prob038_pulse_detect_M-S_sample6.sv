module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] counter; // 2-bit counter to track input signal sequence

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'b00; // Initialize counter to zero
        data_out <= 0;
    end else begin
        if (data_in) begin
            counter <= counter + 1; // Increment counter when data_in is 1
        end else if (counter == 2'b10) begin
            counter <= 2'b00; // Reset counter when data_in is 0 and counter is 2
            data_out <= 1; // Set data_out to 1 when counter reaches 2 and data_in is 0
        end else if (counter != 2'b00) begin
            counter <= 2'b00; // Reset counter when data_in is 0 and counter is not 2
        end else begin
            data_out <= 0; // Set data_out to 0 when counter is not 2
        end
    end
end

endmodule