module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0] accumulator;
reg [1:0] counter;
reg [9:0] output_data;
reg        output_valid;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 0;
        counter     <= 0;
        output_valid <= 0;
    end else if (valid_in) begin
        if (counter < 4) begin
            accumulator <= accumulator + data_in;
            counter     <= counter + 1;
        end
        if (counter == 4) begin
            output_data   <= accumulator;
            output_valid  <= 1;
            accumulator   <= 0;
            counter       <= 0;
        end
    end else if (output_valid) begin
        output_valid <= 0;
    end
end

assign valid_out = output_valid;
assign data_out  = output_data;

endmodule