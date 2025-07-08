module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output reg      valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;           // counts valid inputs, from 0 to 3
    reg [9:0] accumulator;     // 10 bits to hold sum of four 8-bit numbers (max 4*255=1020 < 1024)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 2'd0;
            accumulator <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default output pulse clear

            if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 2'd1;

                if (count == 2'd3) begin
                    data_out  <= accumulator + data_in;  // include current data_in in sum
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule