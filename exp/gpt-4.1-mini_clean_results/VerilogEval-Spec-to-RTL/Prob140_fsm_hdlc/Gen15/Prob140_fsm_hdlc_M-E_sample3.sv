module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum logic [3:0] {
        S0 = 4'd0, // no consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7  // error state: 7 or more consecutive ones
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // stay in error on further ones, reset on zero
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore outputs depend only on current_state and input)
    wire disc_w = (current_state == S5) && (in == 1'b0); // zero after 5 ones
    wire flag_w = (current_state == S6) && (in == 1'b0); // zero after 6 ones
    wire err_w  = (current_state == S7);                 // error state active

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            current_state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule