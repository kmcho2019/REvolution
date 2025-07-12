module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] counter;      // Counts 0-3 (4 inputs)
    reg [9:0] accumulator;  // Stores running sum

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;  // Default value
            
            if (valid_in) begin
                accumulator <= accumulator + data_in;
                
                if (counter == 2'b11) begin
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    counter <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
        end
    end

endmodule