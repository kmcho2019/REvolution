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

    // Enable signal for updating accumulator and count registers only when valid_in is high
    wire update_enable = valid_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default: no valid_out pulse

            if (update_enable) begin
                if (count == 2'd3) begin
                    // On receiving 4th valid input, output the accumulated sum + current data_in
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate data and increment count for inputs 1 to 3
                    accumulator <= accumulator + data_in;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule