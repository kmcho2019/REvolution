module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] accumulated_data [0:3];
reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_out <= 0;
        data_out <= 0;
        counter <= 0;
        for (int i = 0; i < 4; i++) begin
            accumulated_data[i] <= 0;
        end
    end else begin
        if (valid_in) begin
            accumulated_data[counter] <= data_in;
            if (counter == 3) begin
                sum <= accumulated_data[0] + accumulated_data[1] + accumulated_data[2] + accumulated_data[3];
                valid_out <= 1;
                data_out <= sum;
                counter <= 0;
            end else begin
                counter <= counter + 1;
                valid_out <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule