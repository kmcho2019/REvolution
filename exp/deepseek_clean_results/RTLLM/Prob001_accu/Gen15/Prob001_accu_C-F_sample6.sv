module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State and counter combined
    reg [1:0] count;
    reg [9:0] accumulator;
    reg [7:0] input_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            input_reg <= 8'b0;
        end else begin
            // Default assignments
            valid_out <= 1'b0;
            input_reg <= data_in;

            if (valid_in) begin
                // Pipeline stage 1: register input
                // Pipeline stage 2: perform addition
                accumulator <= accumulator + input_reg;
                
                // Update counter
                if (count == 2'b11) begin
                    data_out <= accumulator + input_reg;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                    count <= 2'b0;
                end else begin
                    count <= count + 1'b1;
                end
            end else begin
                // Power optimization: hold values when not valid
                accumulator <= accumulator;
                count <= count;
            end
        end
    end

endmodule