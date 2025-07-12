module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @ (posedge clk) begin
    if (!j && !k) begin
        // do nothing, keep the current state
    end else if (!j && k) begin
        Q <= 1'b0;
    end else if (j && !k) begin
        Q <= 1'b1;
    end else if (j && k) begin
        Q <= ~Q; // toggle the current state
    end
end

endmodule