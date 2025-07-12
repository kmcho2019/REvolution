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

    reg [9:0] accumulator_next;
    reg [1:0] count_next;
    reg       valid_out_next;
    reg [9:0] data_out_next;

    // Sequential block: state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            accumulator <= accumulator_next;
            count       <= count_next;
            data_out    <= data_out_next;
            valid_out   <= valid_out_next;
        end
    end

    // Combinational block: next state logic
    always @(*) begin
        // Default assignments: hold current values and no valid_out
        accumulator_next = accumulator;
        count_next       = count;
        data_out_next    = data_out;
        valid_out_next   = 1'b0;

        if (valid_in) begin
            if (count == 2'd3) begin
                // On fourth valid input, output the sum of 4 data_in values
                data_out_next  = accumulator + data_in;
                valid_out_next = 1'b1;
                accumulator_next = 10'd0;
                count_next       = 2'd0;
            end else begin
                // Accumulate data and increment count
                accumulator_next = accumulator + data_in;
                count_next       = count + 1'b1;
            end
        end
        // If valid_in is low, hold values (no update)
    end

endmodule