module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// One-hot encoded state definitions
localparam [9:0] S0  = 10'b0000000001;
localparam [9:0] S1  = 10'b0000000010;
localparam [9:0] S2  = 10'b0000000100;
localparam [9:0] S3  = 10'b0000001000;
localparam [9:0] S4  = 10'b0000010000;
localparam [9:0] S5  = 10'b0000100000;
localparam [9:0] S6  = 10'b0001000000;
localparam [9:0] S7  = 10'b0010000000;
localparam [9:0] S8  = 10'b0100000000;
localparam [9:0] S9  = 10'b1000000000;

reg [9:0] state, next_state;

// State transition logic
always @(*) begin
    if (reset) begin
        next_state = S0;
    end
    else if (slowena) begin
        case (1'b1) // synthesis parallel_case
            state[S0]: next_state = S1;
            state[S1]: next_state = S2;
            state[S2]: next_state = S3;
            state[S3]: next_state = S4;
            state[S4]: next_state = S5;
            state[S5]: next_state = S6;
            state[S6]: next_state = S7;
            state[S7]: next_state = S8;
            state[S8]: next_state = S9;
            state[S9]: next_state = S0;
            default:   next_state = S0;
        endcase
    end
    else begin
        next_state = state;
    end
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output encoding
always @(*) begin
    case (1'b1) // synthesis parallel_case
        state[S0]: q = 4'b0000;
        state[S1]: q = 4'b0001;
        state[S2]: q = 4'b0010;
        state[S3]: q = 4'b0011;
        state[S4]: q = 4'b0100;
        state[S5]: q = 4'b0101;
        state[S6]: q = 4'b0110;
        state[S7]: q = 4'b0111;
        state[S8]: q = 4'b1000;
        state[S9]: q = 4'b1001;
        default:   q = 4'b0000;
    endcase
end

endmodule