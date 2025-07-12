module width_8to16(
    input clk, 
    input rst_n, 
    input valid_in, 
    input [7:0] data_in, 
    output reg valid_out, 
    output reg [15:0] data_out
);

reg [7:0] data_lock; // register to store the first 8-bit data
reg flag; // flag signal to track whether the first 8-bit data has arrived

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // reset
        valid_out <= 0;
        data_out <= 0;
        data_lock <= 0;
        flag <= 0;
    end else begin
        if (valid_in && !flag) begin // first valid 8-bit data arrived
            data_lock <= data_in;
            flag <= 1;
            valid_out <= 0;
        end else if (valid_in && flag) begin // second valid 8-bit data arrived
            data_out <= {data_lock, data_in};
            valid_out <= 1;
            flag <= 0; // reset flag for next pair of data
        end else begin
            valid_out <= 0; // no valid data
        end
    end
end

endmodule