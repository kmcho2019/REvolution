module accu (
    input              clk,
    input              rst_n,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         valid_out,
    output reg [9:0]   data_out
);

    reg [9:0] acc;        // accumulator for sum (max 4*255=1020 < 10 bits)
    reg [1:0] count;      // count valid inputs (0 to 3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc       <= 10'd0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default to 0

            if (valid_in) begin
                acc   <= acc + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // On receiving the 4th data
                    data_out  <= acc + data_in;
                    valid_out <= 1'b1;
                    acc       <= 10'd0;
                    count     <= 2'd0;
                end
            end
        end
    end

endmodule