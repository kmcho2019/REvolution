module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: number of consecutive ones counted
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // 7 or more consecutive ones => error

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // Stay in error if input=1, else reset count
            default: next_state = S0;
        endcase
    end

    // Combinational output logic
    wire disc_w = (state == S5) && (in == 1'b0);
    wire flag_w = (state == S6) && (in == 1'b0);
    // err asserted if next_state is S7 (error detected this cycle, or continuing error)
    wire err_w  = (next_state == S7);

    // Sequential state and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;  // output asserted for one cycle starting one cycle after pattern
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule