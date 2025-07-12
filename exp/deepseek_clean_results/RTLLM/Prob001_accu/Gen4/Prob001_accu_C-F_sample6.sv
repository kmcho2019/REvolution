module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accumulator;
reg [1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 10'b0;
        counter <= 2'b0;
        data_out <= 10'b0;
        valid_out <= 1'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Only process when valid input arrives
        if (valid_in) begin
            // Update accumulator
            accumulator <= accumulator + data_in;
            
            // Check if we've received 4 inputs
            if (counter == 2'b11) begin
                data_out <= accumulator + data_in;
                valid_out <= 1'b1;
                accumulator <= 10'b0;
                counter <= 2'b0;
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end
end

endmodule