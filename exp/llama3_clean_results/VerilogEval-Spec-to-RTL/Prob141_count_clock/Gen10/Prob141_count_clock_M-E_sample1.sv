module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [31:0] total_seconds;
reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 32'd0;
    end else if (ena) begin
        total_seconds <= total_seconds + 1;
    end
end

always @(*) begin
    seconds = total_seconds % 60;
    minutes = (total_seconds / 60) % 60;
    hours = (total_seconds / 3600) % 12;

    if (hours == 0) begin
        hours = 12;
    end

    if ((total_seconds / 3600) >= 12) begin
        pm = 1'b1;
    end else begin
        pm = 1'b0;
    end
end

assign hh = {4'd0, hours};
assign mm = {2'd0, minutes};
assign ss = {2'd0, seconds};

endmodule