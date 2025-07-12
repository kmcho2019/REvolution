module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;  // 2-bit counter (0-3)

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 2'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;  // Default to 0
            
            if (valid_in) begin
                if (count == 2'b11) begin
                    // On 4th input: output sum and reset
                    data_out <= data_out + data_in;
                    valid_out <= 1'b1;
                    data_out <= 10'b0;
                    count <= 2'b0;
                end
                else begin
                    // Accumulate input
                    data_out <= data_out + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule