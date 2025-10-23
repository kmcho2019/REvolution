module TopModule (
    input [2:0] a,
    output reg [15:0] q
);

// Output value definitions
localparam [15:0] Q0 = 16'h1232,
                  Q1 = 16'haee0,
                  Q2 = 16'h27d4,
                  Q3 = 16'h5a0e,
                  Q4 = 16'h2066,
                  Q5 = 16'h64ce,
                  Q6 = 16'hc526,
                  Q7 = 16'h2f19;

always @(*) begin
    case (a)
        3'd0: q = Q0;
        3'd1: q = Q1;
        3'd2: q = Q2;
        3'd3: q = Q3;
        3'd4: q = Q4;
        3'd5: q = Q5;
        3'd6: q = Q6;
        3'd7: q = Q7;
    endcase
end

endmodule