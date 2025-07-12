module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state; // current state of the cells
reg [511:0] nextState; // next state of the cells

always @(posedge clk) begin
    if (load) begin
        state <= data; // load data into state array
    end else begin
        state <= nextState; // update state array with next state array
    end
end

always @(*) begin
    // calculate next state of each cell
    for (int i = 0; i < 512; i++) begin
        // handle boundaries
        reg left, center, right;
        if (i == 0) begin
            left = 1'b0; // q[-1] is zero
            center = state[i];
            right = state[i + 1];
        end else if (i == 511) begin
            left = state[i - 1];
            center = state[i];
            right = 1'b0; // q[512] is zero
        end else begin
            left = state[i - 1];
            center = state[i];
            right = state[i + 1];
        end
        
        // calculate next state using Rule 90
        nextState[i] = left ^ right;
    end
end

assign q = state; // output current state of the cells

endmodule