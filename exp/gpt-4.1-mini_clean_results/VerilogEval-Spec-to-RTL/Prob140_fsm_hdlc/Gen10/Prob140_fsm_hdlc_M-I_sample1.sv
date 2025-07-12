module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot states: s0 to s7, s0 = 8'b0000_0001, s1=8'b0000_0010, ..., s7=8'b1000_0000
    reg [7:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        if (in == 1'b0) begin
            next_state = 8'b0000_0001; // s0 on zero input
        end else begin
            // Shift one-hot left if not at s7, else remain in s7
            if (state[7]) begin
                next_state = 8'b1000_0000; // s7 stays s7 (error)
            end else begin
                next_state = state << 1;
            end
        end
    end

    // Outputs combinational logic based on previous state and input (Moore FSM outputs asserted next cycle)
    wire disc_w = (state[5]) && (in == 1'b0);  // state s5 + input 0 => discard bit
    wire flag_w = (state[6]) && (in == 1'b0);  // state s6 + input 0 => flag
    wire err_w  = (next_state[7]);              // next state s7 => error

    // Sequential logic for state and registered outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b0000_0001; // s0 on reset (previous input 0)
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule