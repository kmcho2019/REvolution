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
reg [9:0] next_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        sum <= 0;
    end else begin
        if (valid_in) begin
            next_sum <= sum + data_in;
            if (counter == 3) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            next_sum <= 0;
            counter <= 0;
        end
    end
end

always @(posedge clk) begin
    sum <= next_sum;
end

assign valid_out = (counter == 0) && (sum!= 0);
assign data_out = sum;

endmodule