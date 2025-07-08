module accu(
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
        if(!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            valid_out <= 1'b0; // default: no valid output
            if(valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;
                if(count == 2'd3) begin
                    data_out <= accumulator + data_in; // sum 4 values
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule