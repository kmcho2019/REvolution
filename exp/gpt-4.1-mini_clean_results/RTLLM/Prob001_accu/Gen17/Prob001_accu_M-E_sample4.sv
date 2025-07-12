module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [2:0] count;  // 3 bits to count up to 4 (0 to 4)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 3'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no output pulse

            if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 3'd1;

                if (count == 3'd3) begin
                    // This is the 4th valid input
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 3'd0;
                end
            end
        end
    end

endmodule