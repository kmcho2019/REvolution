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

    // Enable updates only when valid_in is high to reduce switching
    wire update_enable = valid_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            // Default output valid_out to 0 for one-cycle pulse
            valid_out <= 1'b0;

            if (update_enable) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output sum of all 4 inputs
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    // Reset accumulator and count for next accumulation cycle
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate first three inputs progressively
                    accumulator <= accumulator + data_in;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule