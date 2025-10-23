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

    // Internal signals
    reg [9:0] sum_next;
    reg       output_pulse;

    always @(*) begin
        // Default next sum is current accumulator
        sum_next = accumulator;
        output_pulse = 1'b0;

        if (valid_in) begin
            if (count == 2'd3) begin
                // On 4th valid input, prepare to output sum of 4 inputs
                sum_next = accumulator + data_in;
                output_pulse = 1'b1;
            end else begin
                // Accumulate inputs up to count 2
                sum_next = accumulator + data_in;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no pulse

            if (valid_in) begin
                if (count == 2'd3) begin
                    // Output accumulated sum and pulse valid_out
                    data_out  <= sum_next;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate and count normally
                    accumulator <= sum_next;
                    count       <= count + 1'b1;
                end
            end
            // else: hold accumulator and count (no toggling)
        end
    end

endmodule