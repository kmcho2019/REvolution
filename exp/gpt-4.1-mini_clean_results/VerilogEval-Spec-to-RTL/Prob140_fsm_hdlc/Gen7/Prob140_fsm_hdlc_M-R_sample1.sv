module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    localparam S0  = 3'd0; // 0 consecutive ones
    localparam S1  = 3'd1; // 1 consecutive one
    localparam S2  = 3'd2; // 2 consecutive ones
    localparam S3  = 3'd3; // 3 consecutive ones
    localparam S4  = 3'd4; // 4 consecutive ones
    localparam S5  = 3'd5; // 5 consecutive ones
    localparam S6  = 3'd6; // 6 consecutive ones
    localparam ERR = 3'd7; // 7 or more consecutive ones (error)

    reg [2:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case(state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? ERR : S0;
            ERR: next_state = in ? ERR : S0;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Detect conditions combinationally from current state and input
    // Condition detected during this cycle:
    wire disc_d = (state == S5) && (in == 1'b0);  // zero after 5 ones -> discard this zero
    wire flag_d = (state == S6) && (in == 1'b0);  // zero after 6 ones -> flag sequence
    wire err_d  = (state == ERR);                  // error state (7 or more ones)

    // Register detected conditions to assert outputs next clock cycle
    reg disc_r, flag_r, err_r;
    always @(posedge clk) begin
        if (reset) begin
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r  <= 1'b0;
        end else begin
            disc_r <= disc_d;
            flag_r <= flag_d;
            err_r  <= err_d;
        end
    end

    // Outputs asserted for one full cycle after detection
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= disc_r;
            flag <= flag_r;
            err  <= err_r;
        end
    end

endmodule