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

    // Enable accumulator update only when valid_in asserted
    wire acc_en = valid_in;

    // Next accumulator value
    wire [9:0] acc_next = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default deassert

            if (acc_en) begin
                if (count == 2'd3) begin
                    // On 4th valid input: output sum and reset
                    data_out  <= acc_next;
                    valid_out <= 1'b1;

                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    // Accumulate and increment counter
                    accumulator <= acc_next;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule