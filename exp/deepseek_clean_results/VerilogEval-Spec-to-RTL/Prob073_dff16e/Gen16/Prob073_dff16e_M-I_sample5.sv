module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Combinational logic for next state
    wire [15:0] next_q = !resetn ? 16'h0 :
                        {byteena[1] ? d[15:8] : q[15:8],
                         byteena[0] ? d[7:0]  : q[7:0]};

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule