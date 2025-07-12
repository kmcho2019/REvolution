module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

// State definitions
reg has_first_byte;  // 0: waiting for first byte, 1: has first byte waiting for second
reg [7:0] stored_byte;
wire [15:0] output_data;

// Combinational output logic
assign output_data = {stored_byte, data_in};
assign valid_out = has_first_byte & valid_in;
assign data_out = output_data;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        stored_byte <= 8'b0;
    end else begin
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte
                stored_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Got second byte - reset for next pair
                has_first_byte <= 1'b0;
            end
        end
    end
end

endmodule