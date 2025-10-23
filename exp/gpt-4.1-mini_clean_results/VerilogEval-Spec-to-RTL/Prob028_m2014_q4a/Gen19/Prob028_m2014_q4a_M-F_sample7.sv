module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    always @(posedge ena) begin
        q <= d;
    end

endmodule