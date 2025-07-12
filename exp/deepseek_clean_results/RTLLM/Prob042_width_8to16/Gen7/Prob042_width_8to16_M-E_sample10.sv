module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [1:0] byte_cnt;
reg [15:0] data_shift_reg;
reg valid_in_prev;

// Edge detection for valid_in
wire valid_in_posedge = valid_in && !valid_in_prev;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        byte_cnt <= 2'b00;
        data_shift_reg <= 16'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        valid_in_prev <= 1'b0;
    end else begin
        valid_in_prev <= valid_in;
        
        // Shift in new data on valid_in posedge
        if (valid_in_posedge) begin
            data_shift_reg <= {data_shift_reg[7:0], data_in};
            byte_cnt <= byte_cnt + 1;
        end
        
        // Generate output when we have 2 bytes
        valid_out <= (byte_cnt == 2'b01) && valid_in_posedge;
        
        if ((byte_cnt == 2'b01) && valid_in_posedge) begin
            data_out <= {data_shift_reg[7:0], data_in};
            byte_cnt <= 2'b00;
        end
    end
end

endmodule