module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] accum;
reg [1:0] count;
reg prev_valid_in;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accum <= 0;
        count <= 0;
        valid_out <= 0;
        prev_valid_in <= 0;
    end else begin
        prev_valid_in <= valid_in;
        if (valid_in && !prev_valid_in) begin // Check for rising edge of valid_in
            accum <= accum + data_in;
            count <= count + 1;
            valid_out <= (count == 4) ? 1 : 0;
        end
        if (count == 4) begin
            accum <= 0;
            count <= 0;
        end else if (~valid_in) begin
            // Do nothing, keep accum and count as they are
        end
        if (~valid_in && prev_valid_in) begin // Check for falling edge of valid_in
            // Reset accum and count if no new data is coming
            accum <= 0;
            count <= 0;
        end
    end
end

assign data_out = accum;

endmodule