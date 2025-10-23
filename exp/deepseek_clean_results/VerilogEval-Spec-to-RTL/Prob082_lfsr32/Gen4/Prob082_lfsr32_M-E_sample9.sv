module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback;
wire [31:0] next_q;

assign feedback = q[0];

// Explicit tap handling
wire tap31, tap21, tap1, tap0;
assign tap31 = q[31] ^ feedback;
assign tap21 = q[21] ^ feedback;
assign tap1 = q[1] ^ feedback;
assign tap0 = q[0] ^ feedback;

// Construct next state
assign next_q = {tap31, q[30:22], tap21, q[20:2], tap1, tap0};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= next_q;
    end
end

endmodule