module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [31:0] seconds_counter;

always @(posedge clk) begin
    if (reset) begin
        seconds_counter <= 32'd0;
    end else if (ena) begin
        seconds_counter <= seconds_counter + 1;
    end
end

wire [4:0] hours = seconds_counter[11:7];
wire [5:0] minutes = seconds_counter[6:1];
wire [5:0] seconds = seconds_counter[0:0] + (seconds_counter[5:1] * 10);

assign pm = (hours > 12) ? 1'b1 : 1'b0;
assign hh = (hours < 10) ? {4'b0000, hours} : {4'b0001, hours - 10};
assign mm = (minutes < 10) ? {4'b0000, minutes} : {4'b0001, minutes - 10};
assign ss = (seconds < 10) ? {4'b0000, seconds} : {4'b0001, seconds - 10};

endmodule