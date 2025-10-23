module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg  [9:0] accumulator;
    reg  [1:0] count;
    wire [9:0] acc_next;

    // Compute next accumulator value (current sum + new data_in)
    assign acc_next = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            // Default valid_out low - pulse for one cycle on output
            valid_out <= 1'b0;

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output sum and pulse valid_out
                    data_out  <= acc_next;
                    valid_out <= 1'b1;
                    // Reset accumulator and count for next group
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate current data_in
                    accumulator <= acc_next;
                    count       <= count + 1'b1;
                end
            end
            // If valid_in is low, hold accumulator and count
        end
    end

endmodule