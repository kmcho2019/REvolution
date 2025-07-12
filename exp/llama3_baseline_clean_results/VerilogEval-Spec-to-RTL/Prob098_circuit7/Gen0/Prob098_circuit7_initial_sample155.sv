module TopModule(
    input clk,
    input a,
    output reg q
);

always @ (posedge clk) begin
    if (a) begin
        q <= 0; // When a is 1, set q to 0
    end else begin
        if (q === 1'bx) begin // If q is not yet defined (initial condition)
            q <= 1; // Set q to 1 when a is 0 for the first time
        end
    end
end

endmodule