module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output wire        valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;

    // valid_out pulse when count == 3 and valid_in is asserted (4th data)
    assign valid_out = (count == 2'd3) && valid_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
        end else if (valid_in) begin
            if (count == 2'd3) begin
                data_out    <= accumulator + data_in;
                accumulator <= 10'd0;
                count       <= 2'd0;
            end else begin
                accumulator <= accumulator + data_in;
                count       <= count + 1'b1;
            end
        end
    end

endmodule