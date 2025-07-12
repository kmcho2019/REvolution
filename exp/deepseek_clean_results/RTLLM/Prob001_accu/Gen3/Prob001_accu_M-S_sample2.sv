module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (valid_out) begin
                // Reset after output
                sum <= data_in;
            end
            else begin
                sum <= sum + data_in;
            end
            valid_out <= (&sum[1:0]); // Detect every 4th input
        end
        
        if (valid_out) begin
            data_out <= sum;
        end
    end
end

endmodule