module accu (
    input           clk,
    input           rst_n,
    input  [7:0]    data_in,
    input           valid_in,
    output reg      valid_out,
    output reg [9:0] data_out
);

    reg [9:0] acc;
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default low, only high when 4 samples accumulated

            if (valid_in) begin
                acc <= acc + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // This is the 4th valid input (0-based count)
                    data_out <= acc + data_in;
                    valid_out <= 1'b1;
                    acc <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule