module TopModule(
    input clk,
    input d,
    output reg q
);
    // Consider adding a reset condition if the design requires it.
    always_ff @(posedge clk) begin
        q <= d;
    end
endmodule