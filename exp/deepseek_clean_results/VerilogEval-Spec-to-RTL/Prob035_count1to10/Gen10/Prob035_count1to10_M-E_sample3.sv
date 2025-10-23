module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// State definitions
localparam S1  = 4'b0001;
localparam S2  = 4'b0010;
localparam S3  = 4'b0011;
localparam S4  = 4'b0100;
localparam S5  = 4'b0101;
localparam S6  = 4'b0110;
localparam S7  = 4'b0111;
localparam S8  = 4'b1000;
localparam S9  = 4'b1001;
localparam S10 = 4'b1010;

always @(posedge clk) begin
    if (reset) begin
        q <= S1;
    end else begin
        case (q)
            S1:  q <= S2;
            S2:  q <= S3;
            S3:  q <= S4;
            S4:  q <= S5;
            S5:  q <= S6;
            S6:  q <= S7;
            S7:  q <= S8;
            S8:  q <= S9;
            S9:  q <= S10;
            S10: q <= S1;
            default: q <= S1;
        endcase
    end
end

endmodule