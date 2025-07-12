module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// One-hot state encoding (10 states for 1-10)
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

// State transition and output logic
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

// Priority encoder for output
always @(*) begin
    case (1'b1)
        state[0]: q = 4'b0001; // 1
        state[1]: q = 4'b0010; // 2
        state[2]: q = 4'b0011; // 3
        state[3]: q = 4'b0100; // 4
        state[4]: q = 4'b0101; // 5
        state[5]: q = 4'b0110; // 6
        state[6]: q = 4'b0111; // 7
        state[7]: q = 4'b1000; // 8
        state[8]: q = 4'b1001; // 9
        state[9]: q = 4'b1010; // 10
        default:  q = 4'b0001; // default to 1
    endcase
end

endmodule