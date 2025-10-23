module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

initial Q = 0; // Initialize Q to 0 at the start of the simulation

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        // No change, Q retains its current value
    end else if (j == 0 && k == 1) begin
        Q <= 0;
    end else if (j == 1 && k == 0) begin
        Q <= 1;
    end else if (j == 1 && k == 1) begin
        Q <= ~Q;
    end
end

endmodule