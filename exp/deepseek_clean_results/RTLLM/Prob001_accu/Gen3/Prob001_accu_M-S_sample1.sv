module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;      // Counter for 0-3 (4 inputs)
    reg [9:0] accumulator; // Accumulator register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
        end
        else if (valid_in) begin
            accumulator <= accumulator + data_in;
            count <= count + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
        end
        else if (valid_in && (count == 2'b11)) begin
            data_out <= accumulator + data_in;
        end
    end

    assign valid_out = valid_in && (count == 2'b11);

endmodule