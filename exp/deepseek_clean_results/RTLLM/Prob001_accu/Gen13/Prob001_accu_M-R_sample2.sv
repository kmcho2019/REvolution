module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

    reg [1:0] count;        // 2-bit counter (0-3)
    reg [9:0] accumulator;  // 10-bit accumulator
    reg [9:0] sum_reg;      // Output register

    // Combinational outputs
    assign valid_out = (count == 2'b11) & valid_in;
    assign data_out = sum_reg;

    // Counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
        end
        else if (valid_in) begin
            count <= (count == 2'b11) ? 2'b00 : count + 1'b1;
        end
    end

    // Accumulator and output update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
            sum_reg <= 10'b0;
        end
        else if (valid_in) begin
            accumulator <= (count == 2'b11) ? data_in : accumulator + data_in;
            sum_reg <= (count == 2'b11) ? (accumulator + data_in) : sum_reg;
        end
    end

endmodule