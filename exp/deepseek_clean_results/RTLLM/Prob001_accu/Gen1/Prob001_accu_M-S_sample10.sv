module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accumulator;  // Stores running sum (8+8+8+8 = max 1020)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        valid_out <= 1'b0;  // Default
        
        if (valid_in) begin
            if (accumulator[9:8] == 2'b11) begin  // Implicit count of 3
                data_out <= accumulator + data_in;
                valid_out <= 1'b1;
                accumulator <= 10'b0;
            end
            else begin
                accumulator <= accumulator + data_in;
            end
        end
    end
end

endmodule