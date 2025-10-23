module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Initialization for simulation safety; synthesis tools usually ignore initial blocks or can be removed
    initial q = 4'b0000;

    always @(posedge clk) begin
        if (shift_ena || count_ena) begin
            // Shift MSB-first: shift left by one, input 'data' at LSB when shifting;
            // else decrement q.
            // Priority doesn't matter when both are high per spec.
            q <= shift_ena ? {q[2:0], data} : (q - 1);
        end
        // else retain current q
    end

endmodule