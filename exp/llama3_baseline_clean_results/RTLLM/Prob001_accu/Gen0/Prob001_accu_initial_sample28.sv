module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] sum;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        sum <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            counter <= counter + 1;
        end
        if (counter == 4) begin
            data_out <= sum;
            valid_out <= 1;
            counter <= 0;
            sum <= 0;
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule