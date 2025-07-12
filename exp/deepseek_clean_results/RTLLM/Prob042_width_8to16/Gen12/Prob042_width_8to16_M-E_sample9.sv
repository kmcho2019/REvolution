module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [1:0] byte_counter;
reg [15:0] data_accum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        byte_counter <= 2'b00;
        data_accum <= 16'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;  // Default to not valid
        
        if (valid_in) begin
            // Shift and accumulate new byte
            data_accum <= {data_accum[7:0], data_in};
            byte_counter <= byte_counter + 1;
            
            // When we have two bytes, output them
            if (byte_counter == 2'b01) begin
                data_out <= {data_accum[7:0], data_in};
                valid_out <= 1'b1;
                byte_counter <= 2'b00;
            end
        end
    end
end

endmodule