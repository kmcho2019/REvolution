module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] current_sum;
reg [9:0] accumulated_sum;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        current_sum <= 0;
        accumulated_sum <= 0;
        valid_out <= 0;
    end else begin
        if (valid_in) begin
            current_sum <= current_sum + data_in;
            counter <= counter + 1;
            if (counter == 4) begin
                accumulated_sum <= current_sum;
                valid_out <= 1;
                counter <= 0;
                current_sum <= 0;
            end else begin
                valid_out <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
end

always @ (posedge clk) begin
    if (valid_out) begin
        data_out <= accumulated_sum;
    end else begin
        data_out <= 0;
    end
    if (valid_out) begin
        valid_out <= 0;
    end
end

endmodule