module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;
    wire [9:0] next_accum = accumulator + data_in;
    wire count_full = (count == 2'b11);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
        end
        else if (valid_in) begin
            count <= count_full ? 2'b00 : (count + 1'b1);
        end
    end

    // Accumulator logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
        end
        else if (valid_in) begin
            accumulator <= count_full ? 10'b0 : next_accum;
        end
    end

    // Output logic
    assign data_out = accumulator + data_in;

    // Valid out generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in & count_full;
        end
    end

endmodule