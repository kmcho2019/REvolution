module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

initial Q = 0; // Initialize Q to 0 at the start of the simulation

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        // No change
    end else if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1;
    end else if (j == 1'b1 && k == 1'b1) begin
        Q <= ~Q;
    end
end

endmodule