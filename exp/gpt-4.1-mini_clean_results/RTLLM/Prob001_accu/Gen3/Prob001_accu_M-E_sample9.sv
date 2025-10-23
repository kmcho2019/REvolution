module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [3:0] valid_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator  <= 10'd0;
            valid_shift  <= 4'd0;
            data_out     <= 10'd0;
            valid_out    <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no output this cycle

            if (valid_in) begin
                accumulator <= accumulator + data_in;
                valid_shift <= {valid_shift[2:0], 1'b1}; // shift in '1' for each valid input

                if (&valid_shift) begin // all 4 bits are 1, i.e., 4 valid inputs received
                    data_out  <= accumulator + data_in; // include current input
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    valid_shift <= 4'd0;
                end
            end
        end
    end

endmodule