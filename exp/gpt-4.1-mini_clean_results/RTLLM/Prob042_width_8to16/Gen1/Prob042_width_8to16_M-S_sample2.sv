module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg [7:0] data_second;
    reg flag;
    reg valid_out_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'd0;
            data_second <= 8'd0;
            flag <= 1'b0;
            data_out <= 16'd0;
            valid_out <= 1'b0;
            valid_out_d <= 1'b0;
        end else begin
            valid_out <= valid_out_d;
            valid_out_d <= 1'b0; // Default no valid output this cycle
            
            if (valid_in) begin
                if (!flag) begin
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    data_second <= data_in;
                    flag <= 1'b0;
                    valid_out_d <= 1'b1;
                    data_out <= {data_lock, data_in};
                end
            end
        end
    end

endmodule