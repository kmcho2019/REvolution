module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] acc; // Accumulator for input bits
reg [31:0] result; // Holds the 2's complement result
reg active; // Flag to indicate if the machine is active

always @(posedge clk or posedge areset) begin
    if (areset) begin
        acc <= 0;
        result <= 0;
        active <= 0;
        z <= 0;
    end else begin
        if (!active) begin
            if (x) begin
                acc <= 1;
                result <= 1;
                active <= 1;
            end
        end else begin
            acc <= {acc[30:0], x};
            result <= ~acc + 1;
            z <= result[0];
        end
    end
end

endmodule