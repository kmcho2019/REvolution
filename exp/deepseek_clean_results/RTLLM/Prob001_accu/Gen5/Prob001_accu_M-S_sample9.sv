module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Counter for received data (0-3)
    reg [9:0] accumulator;  // Accumulator for sum

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                if (count[1]) begin  // Equivalent to count == 2'b11
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    accumulator <= accumulator + data_in;
                    count <= count + 1;
                end
            end
        end
    end

endmodule