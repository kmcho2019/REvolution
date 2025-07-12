module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg toggle;            // 1-bit counter (toggles every 2 inputs)
    reg [9:0] accumulator; // Accumulator for sum

    // Assign accumulator directly to output
    assign data_out = accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            toggle <= 1'b0;
            accumulator <= 10'b0;
        end
        else if (valid_in) begin
            // Toggle counter and accumulate
            toggle <= ~toggle;
            accumulator <= toggle ? (accumulator + data_in) : data_in;
        end
    end

    // Valid out is high when toggle is set (every 4th input)
    always @(*) begin
        valid_out = valid_in & toggle & (accumulator == data_in);
    end

endmodule