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

    // Enable updates only when valid_in is asserted
    wire en = valid_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            // Default output valid is 0; pulse high for one cycle when sum is ready
            valid_out <= 1'b0;

            if (en) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output sum of accumulator + current data_in
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;

                    // Reset accumulator and counter for next set of inputs
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate input and increment count
                    accumulator <= accumulator + data_in;
                    count       <= count + 1'b1;
                end
            end
            // When valid_in is low, hold accumulator and count steady to reduce toggling
        end
    end

endmodule