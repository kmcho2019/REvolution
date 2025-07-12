module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter;
reg [9:0] accum;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        accum <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            if (counter < 4) begin
                accum <= accum + data_in;
                counter <= counter + 1;
            end else begin
                valid_out_reg <= 1;
                accum <= 0;
                counter <= 0;
            end
        end else begin
            if (valid_out_reg) begin
                valid_out_reg <= 0;
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = accum;

endmodule