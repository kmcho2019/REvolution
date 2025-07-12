module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg counter;          // 1-bit counter for pair tracking
    reg [9:0] accumulator; // Accumulator for sum

    assign data_out = accumulator; // Direct output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 1'b0;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0; // Default
            
            if (valid_in) begin
                accumulator <= accumulator + data_in;
                
                if (counter) begin
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                end
                
                counter <= ~counter; // Toggle for pair counting
            end
        end
    end

endmodule