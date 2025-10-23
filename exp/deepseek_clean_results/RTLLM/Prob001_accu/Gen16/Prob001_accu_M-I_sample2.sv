module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [7:0] sum_low;  // First stage of pipelined adder
    reg [9:0] sum_high; // Second stage of pipelined adder
    reg [7:0] data_in_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            sum_low <= 8'b0;
            sum_high <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            data_in_reg <= 8'b0;
        end else begin
            // Default assignments
            valid_out <= 1'b0;
            
            // Pipeline stage 1: Register input and first add
            if (valid_in) begin
                data_in_reg <= data_in;
                sum_low <= sum_low + data_in;
            end

            // Pipeline stage 2: Final accumulation
            sum_high <= sum_high + sum_low;
            
            // Counter and output logic
            if (valid_in) begin
                if (count == 2'b11) begin
                    data_out <= sum_high + sum_low + data_in_reg;
                    valid_out <= 1'b1;
                    sum_low <= 8'b0;
                    sum_high <= 10'b0;
                    count <= 2'b0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule