module TopModule (
    input  wire clock,
    input  wire a,
    output wire p,
    output reg  q
);

reg [1:0] counter;

assign p = clock & a;

always @(posedge clock) begin
    if (a) begin
        counter <= counter + 1;
    end
end

always @(negedge clock) begin
    if (counter > 0) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
    counter <= 0;
end

endmodule