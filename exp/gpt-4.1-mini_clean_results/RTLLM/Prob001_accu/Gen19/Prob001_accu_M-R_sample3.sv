module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] sum_reg;
    reg       output_ready;

    // State machine encoding for accumulation phases
    // We don't explicitly declare states since count implicitly indicates phase

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator  <= 10'd0;
            count        <= 2'd0;
            sum_reg      <= 10'd0;
            valid_out    <= 1'b0;
            output_ready <= 1'b0;
            data_out     <= 10'd0;
        end else begin
            valid_out <= output_ready;    // pulse valid_out when output_ready is set
            output_ready <= 1'b0;         // clear output_ready immediately after

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th data input, add data_in to accumulator and prepare output
                    sum_reg <= accumulator + data_in;
                    output_ready <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end

            if (output_ready) begin
                data_out <= sum_reg;
            end
        end
    end

endmodule