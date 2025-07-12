module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] count;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        sum <= 0;
    end else if (valid_in) begin
        if (count < 4) begin
            sum <= sum + data_in;
            count <= count + 1;
        end else begin
            count <= 0;
        end
    end else begin
        count <= 0;
        sum <= 0;
    end
end

assign valid_out = (count == 4);
assign data_out = sum;

endmodule