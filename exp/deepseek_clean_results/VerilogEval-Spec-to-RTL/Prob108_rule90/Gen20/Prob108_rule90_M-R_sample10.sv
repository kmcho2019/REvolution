module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;

// Extend q with zeros at boundaries for neighbor access
wire [WIDTH+1:0] extended_q = {1'b0, q, 1'b0};

// Next state computation - Rule 90
wire [WIDTH-1:0] next_q = extended_q[WIDTH:1] ^ extended_q[WIDTH-1:0];

// State update with load functionality
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule