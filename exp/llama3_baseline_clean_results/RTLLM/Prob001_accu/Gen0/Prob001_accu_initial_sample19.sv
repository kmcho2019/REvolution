module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] accumulator;
reg [1:0] counter;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 0;
        counter <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin
        if (counter < 4) begin
            accumulator <= accumulator + data_in;
            counter <= counter + 1;
            valid_out_reg <= 0;
        end else begin
            data_out <= accumulator;
            valid_out_reg <= 1;
            accumulator <= 0;
            counter <= 0;
        end
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = (counter == 4) ? valid_out_reg : 0;
assign data_out = (counter == 4) ? accumulator : 0;

endmodule