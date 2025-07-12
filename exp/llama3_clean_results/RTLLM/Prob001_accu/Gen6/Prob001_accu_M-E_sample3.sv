module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] sum;
reg [1:0] counter;
reg [9:0] next_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
        counter <= 0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            counter <= counter + 1;
        end else begin
            sum <= sum;
            counter <= counter;
        end
    end
end

assign valid_out = (counter == 4);
assign data_out = (counter == 4) ? sum : 0;

always @(posedge clk) begin
    if (counter == 4) begin
        sum <= 0;
        counter <= 0;
    end
end

endmodule