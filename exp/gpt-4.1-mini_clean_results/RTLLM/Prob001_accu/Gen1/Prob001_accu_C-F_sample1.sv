module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default low each cycle

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On receiving 4th data, output sum, set valid_out, and reset accumulator and count
                    data_out <= accumulator + data_in; // accumulator has sum of first 3
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    // Accumulate and increment count for first 3 data_in inputs
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule