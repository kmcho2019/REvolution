module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg stage;  // 1-bit counter (toggles every valid input)
reg [8:0] pair_sum;  // Stores sum of two inputs (8+8=9 bits)
reg [9:0] total_sum;  // Stores sum of two pairs (9+9=10 bits)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage <= 1'b0;
        pair_sum <= 9'b0;
        total_sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (stage) begin
                // Second input of pair - complete pair_sum
                pair_sum <= pair_sum + data_in;
                // Check if we have two pairs (4 inputs)
                if (&total_sum[8:7]) begin  // Check if total_sum has valid pair
                    data_out <= total_sum + pair_sum + data_in;
                    valid_out <= 1'b1;
                    total_sum <= 10'b0;
                end
                else begin
                    total_sum <= total_sum + pair_sum + data_in;
                end
            end
            else begin
                // First input of pair
                pair_sum <= data_in;
            end
            stage <= ~stage;  // Toggle stage
        end
    end
end

endmodule