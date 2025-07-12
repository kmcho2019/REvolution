module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] accumulator;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        accumulator <= 0;
        valid_out <= 0;
    end else begin
        if (valid_in) begin
            if (counter < 4) begin
                accumulator <= accumulator + data_in;
                counter <= counter + 1;
            end else begin
                accumulator <= data_in;
                counter <= 1;
                valid_out <= 1;
                data_out <= accumulator;
            end
        end else begin
            valid_out <= 0;
        end
        if (counter == 4 && valid_in) begin
            valid_out <= 1;
            data_out <= accumulator;
        end else if (~valid_in) begin
            valid_out <= 0;
        end
        if (valid_out) begin
            valid_out <= 0;
        end
    end
end

endmodule