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

    // Next accumulator value for one cycle addition
    wire [9:0] acc_next = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no output pulse

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output sum and pulse valid_out
                    data_out    <= acc_next;
                    valid_out   <= 1'b1;

                    accumulator <= 10'd0;  // Reset accumulator for next batch
                    count       <= 2'd0;   // Reset count
                end else begin
                    // Accumulate inputs and increment count
                    accumulator <= acc_next;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule