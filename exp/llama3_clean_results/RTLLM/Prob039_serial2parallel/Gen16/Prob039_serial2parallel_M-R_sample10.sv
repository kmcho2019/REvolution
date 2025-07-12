module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

// Combinational logic for counter and output updates
wire [3:0] cnt_next;
wire [7:0] dout_parallel_next;
wire dout_valid_next;

assign cnt_next = (din_valid && cnt < 4'b1000) ? cnt + 1'b1 : (din_valid && cnt == 4'b1000) ? 4'b0000 : cnt;
assign dout_parallel_next = (din_valid && cnt < 4'b1000) ? {dout_parallel[6:0], din_serial} : (cnt == 4'b1000) ? dout_parallel : dout_parallel;
assign dout_valid_next = (cnt == 4'b1000 && din_valid) ? 1'b1 : (din_valid && cnt < 4'b1000) ? 1'b0 : (cnt == 4'b1000 && !din_valid) ? 1'b0 : dout_valid;

// Sequential updates
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, output, and validity signal
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        cnt <= cnt_next;
        dout_parallel <= dout_parallel_next;
        dout_valid <= dout_valid_next;
    end
end

endmodule