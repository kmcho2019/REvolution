module TopModule(
    input  d,
    input  ena,
    output reg q
);
    
    always @(*) begin
        if (ena) begin
            q <= d;
        end else begin
            q <= q; // Retain the current value of q when ena is low
        end
    end

endmodule