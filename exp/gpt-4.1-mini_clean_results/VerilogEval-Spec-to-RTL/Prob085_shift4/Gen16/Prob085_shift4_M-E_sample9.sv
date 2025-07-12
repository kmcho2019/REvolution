module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Next state logic as combinational multiplexer with priority load > ena > hold
wire [3:0] shifted = {1'b0, q[3:1]};
wire [3:0] next_val;

assign next_val = load ? data :
                  ena  ? shifted :
                  q;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000; // Asynchronous reset
    end else begin
        q <= next_val; // Synchronous load, shift, or hold
    end
end

endmodule