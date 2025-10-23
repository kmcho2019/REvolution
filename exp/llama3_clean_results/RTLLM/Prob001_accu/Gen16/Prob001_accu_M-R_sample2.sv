module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        sum <= 0;
    end else if (valid_in) begin
        if (counter < 4) begin
            sum <= sum + data_in;
            counter <= counter + 1;
        end else begin
            counter <= 0;
            sum <= data_in;
        end
    end else begin
        counter <= 0;
        sum <= 0;
    end
end

assign valid_out = (counter == 4);
assign data_out = (counter == 4) ? sum : 0;

endmodule