module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] accumulated_data;
reg [1:0] counter;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulated_data <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd0) begin
            accumulated_data <= data_in;
            counter <= counter + 1'd1;
        end else if (counter < 2'd4) begin
            accumulated_data <= accumulated_data + data_in;
            counter <= counter + 1'd1;
        end else begin
            accumulated_data <= accumulated_data + data_in;
            valid_out_reg <= 1'b1;
            counter <= 2'd0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg)? accumulated_data : 10'd0;

endmodule