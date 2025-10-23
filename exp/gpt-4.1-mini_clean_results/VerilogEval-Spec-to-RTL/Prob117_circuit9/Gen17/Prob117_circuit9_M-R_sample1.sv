module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

localparam [2:0]
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6;

wire [2:0] next_state;

assign next_state = (a) ? S4 : 
                    (q == S4) ? S5 :
                    (q == S5) ? S6 :
                    (q == S6) ? S0 :
                    (q == S0) ? S1 :
                    (q == S1) ? S2 :
                    (q == S2) ? S3 :
                    (q == S3) ? S4 : S4;

always @(posedge clk) begin
    q <= next_state;
end

endmodule