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

    // Enable signal to update registers only when valid_in is asserted
    wire en = valid_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // Default valid_out to 0 each cycle

            if (en) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output sum of 4 inputs
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    // Reset accumulator and count for next accumulation
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate first three inputs and increment count
                    accumulator <= accumulator + data_in;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule