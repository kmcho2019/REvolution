module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: one-hot for counts of consecutive ones
    // S0: 0 consecutive ones (initial/reset state)
    // S1: 1 consecutive one
    // S2: 2 consecutive ones
    // S3: 3 consecutive ones
    // S4: 4 consecutive ones
    // S5: 5 consecutive ones
    // S6: 6 consecutive ones
    // SE: error state (7 or more consecutive ones)
    typedef enum reg [7:0] {
        S0 = 8'b00000001,
        S1 = 8'b00000010,
        S2 = 8'b00000100,
        S3 = 8'b00001000,
        S4 = 8'b00010000,
        S5 = 8'b00100000,
        S6 = 8'b01000000,
        SE = 8'b10000000
    } state_t;

    reg [7:0] state, next_state;

    // Next state logic combinational
    always @* begin
        case(state)
            S0: begin
                // input 1 -> S1; input 0 -> stay S0
                if (in)       next_state = S1;
                else          next_state = S0;
            end
            S1: begin
                // input 1 -> S2; input 0 -> S0
                if (in)       next_state = S2;
                else          next_state = S0;
            end
            S2: begin
                if (in)       next_state = S3;
                else          next_state = S0;
            end
            S3: begin
                if (in)       next_state = S4;
                else          next_state = S0;
            end
            S4: begin
                if (in)       next_state = S5;
                else          next_state = S0;
            end
            S5: begin
                if (in)       next_state = S6;
                else          next_state = S0;
            end
            S6: begin
                if (in)       next_state = SE;
                else          next_state = S0;
            end
            SE: begin
                // Remain in error state on any input
                next_state = SE;
            end
            default: next_state = S0;
        endcase
    end

    // Output logic: Moore outputs based on current state and input
    // disc: detected 5 consecutive ones followed by zero: sequence "0111110"
    //   => current state = S5 and input=0 (means zero after 5 ones)
    // flag: detected 6 consecutive ones followed by zero: "01111110"
    //   => current state = S6 and input=0
    // err: error on 7 or more ones: state SE

    wire disc_w = (state == S5) && (in == 1'b0);
    wire flag_w = (state == S6) && (in == 1'b0);
    wire err_w  = (state == SE);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs asserted for one cycle starting on clock after condition
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule