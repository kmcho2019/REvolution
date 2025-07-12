module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    reg [9:0] accum;
    reg [1:0] count;  // counts from 0 to 3 (4 data inputs)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accum <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default output valid_out low
            if (valid_in) begin
                accum <= accum + data_in;
                count <= count + 1'b1;
                if (count == 2'd3) begin
                    data_out <= accum + data_in; // accum contains sum of previous 3, add 4th now
                    valid_out <= 1'b1;
                    accum <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule