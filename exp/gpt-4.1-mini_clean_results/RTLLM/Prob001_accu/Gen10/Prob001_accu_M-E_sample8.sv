module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_fifo [3:0];  // store up to 4 input data
    reg [1:0] count;             // counts number of stored inputs (0 to 3)
    reg [9:0] accumulator;       // sum of stored inputs

    integer i;

    always @(posedge clk) begin
        if (!rst_n) begin
            count       <= 2'd0;
            accumulator <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
            for (i=0; i<4; i=i+1) begin
                data_fifo[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0;  // default no valid output

            if (valid_in) begin
                // Shift stored inputs left by one
                for (i=3; i>0; i=i-1) begin
                    data_fifo[i] <= data_fifo[i-1];
                end
                data_fifo[0] <= data_in;

                if (count < 2'd3) begin
                    // Accumulate and increment count
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end else begin
                    // On 4th input: add input, output sum, pulse valid_out, reset
                    accumulator <= 10'd0;
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule