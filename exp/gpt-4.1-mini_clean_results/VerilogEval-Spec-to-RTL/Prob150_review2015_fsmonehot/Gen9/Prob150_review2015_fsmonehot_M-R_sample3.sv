module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot encoding as per spec
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit indices
localparam S_BIT    = 0;
localparam S1_BIT   = 1;
localparam S11_BIT  = 2;
localparam S110_BIT = 3;
localparam B0_BIT   = 4;
localparam B1_BIT   = 5;
localparam B2_BIT   = 6;
localparam B3_BIT   = 7;
localparam COUNT_BIT= 8;
localparam WAIT_BIT = 9;

// Current states
wire S    = state[S_BIT];
wire S1   = state[S1_BIT];
wire S11  = state[S11_BIT];
wire S110 = state[S110_BIT];
wire B0   = state[B0_BIT];
wire B1   = state[B1_BIT];
wire B2   = state[B2_BIT];
wire B3   = state[B3_BIT];
wire COUNT= state[COUNT_BIT];
wire WAIT = state[WAIT_BIT];

// Declare next state signals
reg S_next_r, S1_next_r, S11_next_r, S110_next_r;
reg B0_next_r, B1_next_r, B2_next_r, B3_next_r;
reg Count_next_r, Wait_next_r;

always @(*) begin
    // Default all next state outputs to 0
    S_next_r    = 1'b0;
    S1_next_r   = 1'b0;
    S11_next_r  = 1'b0;
    S110_next_r = 1'b0;
    B0_next_r   = 1'b0;
    B1_next_r   = 1'b0;
    B2_next_r   = 1'b0;
    B3_next_r   = 1'b0;
    Count_next_r= 1'b0;
    Wait_next_r = 1'b0;

    // One-hot FSM next-state by current state
    case (1'b1)
        S: begin
            if (d == 1'b0)
                S_next_r = 1'b1;
            else
                S1_next_r = 1'b1;
        end
        S1: begin
            if (d == 1'b0)
                S_next_r = 1'b1;
            else
                S11_next_r = 1'b1;
        end
        S11: begin
            if (d == 1'b0)
                S110_next_r = 1'b1;
            else
                S11_next_r = 1'b1;
        end
        S110: begin
            if (d == 1'b0)
                S_next_r = 1'b1;
            else
                B0_next_r = 1'b1;
        end
        B0:    B1_next_r = 1'b1;
        B1:    B2_next_r = 1'b1;
        B2:    B3_next_r = 1'b1;
        B3:    Count_next_r = 1'b1;
        COUNT: begin
            if (done_counting == 1'b0)
                Count_next_r = 1'b1;
            else
                Wait_next_r = 1'b1;
        end
        WAIT: begin
            if (ack == 1'b0)
                Wait_next_r = 1'b1;
            else
                S_next_r = 1'b1;
        end
        default: S_next_r = 1'b1; // Default state
    endcase
end

// Outputs derived from current state (Moore outputs)
assign shift_ena = B0 | B1 | B2 | B3;
assign counting = COUNT;
assign done = WAIT;

// Assign next state outputs
assign S_next    = S_next_r;
assign S1_next   = S1_next_r;
assign B3_next   = B3_next_r;
assign Count_next= Count_next_r;
assign Wait_next = Wait_next_r;

endmodule