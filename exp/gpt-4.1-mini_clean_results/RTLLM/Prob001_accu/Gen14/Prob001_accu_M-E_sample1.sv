module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] fifo [0:3];        // FIFO to store last four inputs
    reg [1:0] wr_ptr;            // Write pointer for FIFO (0 to 3)
    reg [1:0] count;             // Count valid inputs (0 to 4)
    reg [9:0] acc_sum;           // Accumulated sum of four data inputs

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            acc_sum   <= 10'd0;
            wr_ptr    <= 2'd0;
            count     <= 2'd0;
            // Initialize FIFO to zero for clean reset
            for (i=0; i<4; i=i+1) begin
                fifo[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default no output pulse

            if (valid_in) begin
                if (count < 2'd4) begin
                    // Accumulate new data into sum
                    acc_sum <= acc_sum + data_in;
                    fifo[wr_ptr] <= data_in;
                    wr_ptr <= wr_ptr + 1'b1;
                    count <= count + 1'b1;

                    // When count reaches 4 after this input, output sum
                    if (count == 2'd3) begin
                        data_out <= acc_sum + data_in; // sum of 4 inputs
                        valid_out <= 1'b1;

                        // Reset for next accumulation
                        acc_sum <= 10'd0;
                        count <= 2'd0;
                        wr_ptr <= 2'd0;
                    end
                end
            end
        end
    end

endmodule