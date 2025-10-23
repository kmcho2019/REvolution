module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// One-hot encoded states (10 states for 1-10)
reg [9:0] state;

// State definitions
localparam S1  = 10'b0000000001;
localparam S2  = 10'b0000000010;
localparam S3  = 10'b0000000100;
localparam S4  = 10'b0000001000;
localparam S5  = 10'b0000010000;
localparam S6  = 10'b0000100000;
localparam S7  = 10'b0001000000;
localparam S8  = 10'b0010000000;
localparam S9  = 10'b0100000000;
localparam S10 = 10'b1000000000;

// State transitions
always @(posedge clk) begin
    if (reset) begin
        state <= S1;
    end else begin
        case (state)
            S1:  state <= S2;
            S2:  state <= S3;
            S3:  state <= S4;
            S4:  state <= S5;
            S5:  state <= S6;
            S6:  state <= S7;
            S7:  state <= S8;
            S8:  state <= S9;
            S9:  state <= S10;
            S10: state <= S1;
            default: state <= S1;
        endcase
    end
end

// Binary output decoder
assign q = (state == S1)  ? 4'b0001 :
           (state == S2)  ? 4'b0010 :
           (state == S3)  ? 4'b0011 :
           (state == S4)  ? 4'b0100 :
           (state == S5)  ? 4'b0101 :
           (state == S6)  ? 4'b0110 :
           (state == S7)  ? 4'b0111 :
           (state == S8)  ? 4'b1000 :
           (state == S9)  ? 4'b1001 :
           (state == S10) ? 4'b1010 :
           4'b0000; // default (shouldn't occur)

endmodule