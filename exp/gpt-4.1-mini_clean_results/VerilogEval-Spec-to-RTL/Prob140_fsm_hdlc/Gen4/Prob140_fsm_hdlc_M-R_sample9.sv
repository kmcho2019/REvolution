module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // error state (7 or more 1s)

    reg [2:0] state;
    reg prev_in;

    // Combinational next state logic
    wire [2:0] next_state = (state == S0) ? (in ? S1 : S0) :
                            (state == S1) ? (in ? S2 : S0) :
                            (state == S2) ? (in ? S3 : S0) :
                            (state == S3) ? (in ? S4 : S0) :
                            (state == S4) ? (in ? S5 : S0) :
                            (state == S5) ? (in ? S6 : S0) :
                            (state == S6) ? (in ? S7 : S0) :
                            /* state == S7 */ (in ? S7 : S0);

    // Combinational outputs signals (one cycle early)
    wire disc_int = (state == S5) && (prev_in == 1'b1) && (in == 1'b0);
    wire flag_int = (state == S6) && (prev_in == 1'b1) && (in == 1'b0);
    wire err_int  = (next_state == S7);

    // Sequential state and output registers update
    always @(posedge clk) begin
        if (reset) begin
            state   <= S0;
            prev_in <= 1'b0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            state   <= next_state;
            prev_in <= in;
            disc    <= disc_int;
            flag    <= flag_int;
            err     <= err_int;
        end
    end

endmodule