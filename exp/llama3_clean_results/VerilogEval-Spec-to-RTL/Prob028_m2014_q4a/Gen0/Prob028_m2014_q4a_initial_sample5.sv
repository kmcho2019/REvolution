module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        // No need for an explicit assignment here, 
        // as the non-blocking assignment in the if statement will keep the value of q.
    end
end

endmodule