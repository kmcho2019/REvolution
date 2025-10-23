module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accumulator;
reg [1:0] counter;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 10'd0;
        counter <= 2'd0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        accumulator <= accumulator + data_in;
        counter <= counter + 1'b1;
        if (counter == 2'd3) begin
            data_out <= accumulator;
            valid_out <= 1'b1;
            counter <= 2'd0;
            accumulator <= 10'd0;
        end else begin
            valid_out <= 1'b0;
        end
    end else begin
        valid_out <= 1'b0;
    end
end

endmodule