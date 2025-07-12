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

    // Combinational addition: next accumulator value if data_in is accepted
    assign acc_next = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default no valid output pulse

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output accumulated sum + current input and pulse valid_out
                    data_out    <= acc_next;
                    valid_out   <= 1'b1;
                    // Reset accumulator and count for next batch
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate and increment count for first three inputs
                    accumulator <= acc_next;
                    count       <= count + 1'b1;
                end
            end
            // If valid_in is low, hold accumulator and count without changes
        end
    end

endmodule