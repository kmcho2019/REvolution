module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [1:0] counter;
reg [7:0] temp_data;
reg valid_out_reg;
reg [15:0] data_out_reg; // Declare data_out as a reg

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        temp_data <= 0;
        valid_out_reg <= 0;
        data_out_reg <= 0; // Reset data_out_reg
    end else begin
        if (valid_in) begin
            if (counter == 0) begin
                temp_data <= data_in;
                counter <= 1;
            end else if (counter == 1) begin
                data_out_reg <= {data_in, temp_data};
                valid_out_reg <= 1;
                counter <= 0;
            end
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg; // Assign data_out_reg to data_out

endmodule