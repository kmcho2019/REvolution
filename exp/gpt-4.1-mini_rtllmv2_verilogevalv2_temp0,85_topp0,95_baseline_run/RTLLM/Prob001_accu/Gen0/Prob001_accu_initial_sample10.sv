module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output reg        valid_out,
    output reg [9:0]  data_out
);

    reg [1:0] count;       // count from 0 to 3 (4 inputs)
    reg [9:0] sum;         // sum can be up to 4*255=1020, fits in 10 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'd0;
            sum <= 10'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default 0 each cycle

            if (valid_in) begin
                sum <= sum + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    data_out <= sum + data_in;
                    valid_out <= 1'b1;
                    sum <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule