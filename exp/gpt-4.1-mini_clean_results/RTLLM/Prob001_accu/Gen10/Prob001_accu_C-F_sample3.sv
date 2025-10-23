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
    wire [9:0] next_accum;

    assign next_accum = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no pulse

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th valid input, output accumulated sum + data_in,
                    // pulse valid_out for one cycle, then reset accumulator and count
                    data_out    <= next_accum;
                    valid_out   <= 1'b1;
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    accumulator <= next_accum;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule