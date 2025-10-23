module TopModule (
    input clk,
    input a,
    output reg q
);

// Define states
localparam S0 = 1'b0;  // q = 1
localparam S1 = 1'b1;  // q = 0

reg state;

always @(posedge clk) begin
    case (state)
        S0: state <= a ? S1 : S0;
        S1: state <= a ? S1 : S0;
    endcase
end

// Output logic
always @(*) begin
    q = (state == S0) ? 1'b1 : 1'b0;
end

endmodule