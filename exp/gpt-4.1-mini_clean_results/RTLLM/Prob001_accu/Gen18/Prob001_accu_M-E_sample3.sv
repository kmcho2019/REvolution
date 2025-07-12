module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [8:0] partial_sum1;   // sum of first two inputs (max 2*255=510 < 2^9=512)
    reg [8:0] partial_sum2;   // sum of last two inputs
    reg [1:0] half_count;     // counts inputs within pairs: 0 or 1
    reg [1:0] pair_count;     // counts how many pairs processed: 0 or 1

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum1 <= 9'd0;
            partial_sum2 <= 9'd0;
            half_count   <= 2'd0;
            pair_count   <= 2'd0;
            data_out     <= 10'd0;
            valid_out    <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default no output pulse each cycle

            if (valid_in) begin
                if (pair_count == 2'd0) begin
                    // First pair accumulation
                    if (half_count == 2'd0) begin
                        partial_sum1 <= data_in;
                        half_count <= 2'd1;
                    end else begin
                        partial_sum1 <= partial_sum1 + data_in;
                        half_count <= 2'd0;
                        pair_count <= 2'd1;
                    end
                end else begin
                    // Second pair accumulation
                    if (half_count == 2'd0) begin
                        partial_sum2 <= data_in;
                        half_count <= 2'd1;
                    end else begin
                        partial_sum2 <= partial_sum2 + data_in;
                        half_count <= 2'd0;
                        pair_count <= 2'd0;
                        // Output sum of two partial sums (9-bit + 9-bit = 10-bit max)
                        data_out  <= partial_sum1 + (partial_sum2 + data_in);
                        valid_out <= 1'b1;
                        // Reset partial sums after output
                        partial_sum1 <= 9'd0;
                        partial_sum2 <= 9'd0;
                    end
                end
            end
        end
    end

endmodule