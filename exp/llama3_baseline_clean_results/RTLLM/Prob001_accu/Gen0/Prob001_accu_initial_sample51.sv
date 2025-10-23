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

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 0;
        counter <= 0;
        valid_out <= 0;
    end else begin
        if (valid_in) begin
            if (counter < 4) begin
                accumulator <= accumulator + data_in;
                counter <= counter + 1;
            end else begin
                data_out <= accumulator;
                valid_out <= 1;
                accumulator <= 0;
                counter <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
end

always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 0;
    end
end

endmodule