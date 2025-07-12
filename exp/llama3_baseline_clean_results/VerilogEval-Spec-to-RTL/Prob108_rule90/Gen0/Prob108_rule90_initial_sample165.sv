module TopModule(
    input  clk,
    input  load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] currentState;

always @(posedge clk) begin
    if (load) begin
        currentState <= data;
    end else begin
        reg [511:0] nextState;
        nextState[0] <= currentState[1] ^ 0; // left boundary
        for (int i = 1; i < 511; i++) begin
            nextState[i] <= currentState[i-1] ^ currentState[i+1];
        end
        nextState[511] <= 0 ^ currentState[510]; // right boundary
        currentState <= nextState;
    end
end

assign q = currentState;

endmodule