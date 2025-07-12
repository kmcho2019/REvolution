module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;
    wire count_full = (count == 2'd3);

    // Continuous assignments
    wire [9:0] next_accum = valid_in ? accumulator + data_in : accumulator;
    wire [1:0] next_count = valid_in ? (count_full ? 2'd0 : count + 1'b1) : count;
    wire [9:0] next_data_out = count_full ? next_accum : data_out;
    wire next_valid_out = count_full & valid_in;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'd0;
            accumulator <= 10'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            count <= next_count;
            accumulator <= next_count == 2'd0 ? (valid_in ? data_in : 10'd0) : next_accum;
            data_out <= next_data_out;
            valid_out <= next_valid_out;
        end
    end

endmodule