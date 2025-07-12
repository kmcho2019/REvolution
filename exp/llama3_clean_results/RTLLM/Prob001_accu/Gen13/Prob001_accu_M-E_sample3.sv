module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] buffer [3:0];
reg [2:0] buffer_ptr;
reg [9:0] sum;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        buffer_ptr <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            buffer[buffer_ptr] <= data_in;
            if (buffer_ptr == 3) begin
                sum <= buffer[0] + buffer[1] + buffer[2] + buffer[3];
                valid_out_reg <= 1;
                buffer_ptr <= 0;
            end else begin
                buffer_ptr <= buffer_ptr + 1;
            end
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule