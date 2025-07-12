module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'd0;
        sum <= 10'd0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd3) begin
            sum <= sum + data_in;
            data_out <= sum;
            valid_out <= 1'b1;
            counter <= 2'd0;
            sum <= 10'd0;
        end else begin
            sum <= sum + data_in;
            counter <= counter + 1'b1;
            valid_out <= 1'b0;
        end
    end else begin
        valid_out <= 1'b0;
    end
end

always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 1'b0;
    end
end

endmodule