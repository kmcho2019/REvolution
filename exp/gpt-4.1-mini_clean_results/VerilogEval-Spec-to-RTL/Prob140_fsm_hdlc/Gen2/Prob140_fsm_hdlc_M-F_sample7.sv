module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

// State encoding: count of consecutive 1s seen so far
localparam s0 = 3'd0; // 0 consecutive 1s
localparam s1 = 3'd1; // 1 consecutive 1
localparam s2 = 3'd2; // 2 consecutive 1s
localparam s3 = 3'd3; // 3 consecutive 1s
localparam s4 = 3'd4; // 4 consecutive 1s
localparam s5 = 3'd5; // 5 consecutive 1s
localparam s6 = 3'd6; // 6 consecutive 1s
localparam s7 = 3'd7; // 7 or more consecutive 1s (error)

reg [2:0] state, next_state;

// Combinational next state logic
always @(*) begin
    case (state)
        s0: next_state = in ? s1 : s0;
        s1: next_state = in ? s2 : s0;
        s2: next_state = in ? s3 : s0;
        s3: next_state = in ? s4 : s0;
        s4: next_state = in ? s5 : s0;
        s5: next_state = in ? s6 : s0;
        s6: next_state = in ? s7 : s0;
        s7: next_state = in ? s7 : s0;
        default: next_state = s0;
    endcase
end

// Output signals combinational signals based on previous state and current input
// These signals are latched on clock to produce outputs delayed by one cycle
reg disc_d, flag_d, err_d;

always @(*) begin
    // Defaults
    disc_d = 1'b0;
    flag_d = 1'b0;
    err_d  = 1'b0;

    // Outputs asserted one cycle after detection, i.e., based on previous state (state)
    case(state)
        s5: if (in == 1'b0) disc_d = 1'b1;   // detected 0111110 pattern last cycle
        s6: if (in == 1'b0) flag_d = 1'b1;   // detected 01111110 pattern last cycle
        s7: err_d = 1'b1;                     // detected 7 or more consecutive ones last cycle
    endcase
end

// Sequential logic: update state and outputs at rising clock edge with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= s0;
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        state <= next_state;
        disc <= disc_d;
        flag <= flag_d;
        err  <= err_d;
    end
end

endmodule