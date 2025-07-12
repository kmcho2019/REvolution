module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding as localparams
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // error state (7 or more 1s)

    reg [2:0] state, next_state;
    reg prev_in;
    reg [2:0] prev_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // Output signals combinational based on previous state and inputs
    wire disc_w = (prev_state == S5) && (prev_in == 1'b1) && (in == 1'b0);
    wire flag_w = (prev_state == S6) && (prev_in == 1'b1) && (in == 1'b0);
    wire err_w  = (state == S7);

    // Sequential logic: register state, prev_in, prev_state, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            prev_state <= S0;
            prev_in <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            prev_state <= state;
            prev_in <= in;

            disc <= disc_w;
            flag <= flag_w;
            err <= err_w;
        end
    end

endmodule