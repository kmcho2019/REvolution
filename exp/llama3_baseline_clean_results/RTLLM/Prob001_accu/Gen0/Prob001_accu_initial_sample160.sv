module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter;
reg [7:0] data_array [0:3];
reg [9:0] sum;
reg output_ready;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        output_ready <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_in) begin
            if (counter < 2'b11) begin
                data_array[counter] <= data_in;
                counter <= counter + 1'b1;
            end else begin
                sum <= data_in + data_array[0] + data_array[1] + data_array[2];
                output_ready <= 1'b1;
                counter <= 2'b00;
            end
        end else begin
            output_ready <= 1'b0;
        end

        if (output_ready) begin
            valid_out <= 1'b1;
            data_out <= sum;
        end else begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
    end
end

endmodule