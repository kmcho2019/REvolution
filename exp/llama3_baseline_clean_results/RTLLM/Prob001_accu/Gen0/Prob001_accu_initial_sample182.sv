module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] accumulator;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'd0;
        accumulator <= 10'd0;
        valid_out <= 1'b0;
        data_out <= 10'd0;
    end else begin
        if (valid_in) begin
            if (counter < 2'd3) begin
                accumulator <= accumulator + data_in;
                counter <= counter + 1'd1;
                valid_out <= 1'b0;
            end else begin
                accumulator <= accumulator + data_in;
                valid_out <= 1'b1;
                data_out <= accumulator;
                counter <= 2'd0;
                accumulator <= 10'd0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule