module TopModule #(
    parameter WIDTH = 1
)(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the state
logic [WIDTH-1:0] state;

// Output logic
assign out = state[0];

// State transition logic using a latch
always_latch begin
    if (~reset) begin
        if (j && ~state[0]) begin
            state <= 1'b1;
        end else if (k && state[0]) begin
            state <= 1'b0;
        end
    end else begin
        state <= 1'b0;
    end
end

endmodule