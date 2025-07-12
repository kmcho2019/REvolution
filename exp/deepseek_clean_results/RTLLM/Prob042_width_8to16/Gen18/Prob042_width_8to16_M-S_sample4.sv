module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_data;
reg waiting_second;

always @(posedge clk) begin
    if (!rst_n) begin
        stored_data <= 8'b0;
        waiting_second <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default assignment
        
        if (valid_in) begin
            if (waiting_second) begin
                data_out <= {stored_data, data_in};
                valid_out <= 1'b1;
                waiting_second <= 1'b0;
            end else begin
                stored_data <= data_in;
                waiting_second <= 1'b1;
            end
        end
    end
end

endmodule