module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State encoding
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S0 = 3'b000;
localparam S1 = 3'b001;

always @(posedge clk) begin
    case (q)
        S4: q <= a ? S4 : S5;
        S5: q <= a ? S5 : S6;
        S6: q <= a ? S6 : S0;
        S0: q <= a ? S0 : S1;
        S1: q <= a ? S1 : S4;
        default: q <= S4; // Initialize to 4
    endcase
end

endmodule