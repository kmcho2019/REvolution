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
        valid_out <= 0;
    end else if (valid_in) begin
        if (count == 3) begin
            sum <= sum + data_in;
            valid_out <= 1;
            count <= 0;
        end else begin
            sum <= (count == 0) ? data_in : sum + data_in;
            count <= count + 1;
            valid_out <= 0;
        end
    end else begin
        valid_out <= 0;
    end
end

assign data_out = sum;

endmodule