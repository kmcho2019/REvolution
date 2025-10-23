module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state; // current state of the system

always @(posedge clk) begin
    if (load) begin // if load signal is high, initialize the state with data
        state <= data;
    end else begin // if load signal is low, apply Rule 90 to calculate the next state
        reg [511:0] nextState;
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            // handle boundary conditions
            if (i == 0) begin
                left = 0;
            end else begin
                left = state[i-1];
            end
            center = state[i];
            if (i == 511) begin
                right = 0;
            end else begin
                right = state[i+1];
            end
            // apply Rule 90
            nextState[i] <= left ^ right;
        end
        state <= nextState;
    end
end

assign q = state;

endmodule