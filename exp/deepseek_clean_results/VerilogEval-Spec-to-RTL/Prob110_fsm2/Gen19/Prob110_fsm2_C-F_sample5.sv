module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// State parameters (output equals state in Moore machine)
localparam OFF = 1'b0;
localparam ON  = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= OFF;
    end else begin
        out <= (out) ? ~k : j;  // Efficient state transition logic
    end
end

endmodule