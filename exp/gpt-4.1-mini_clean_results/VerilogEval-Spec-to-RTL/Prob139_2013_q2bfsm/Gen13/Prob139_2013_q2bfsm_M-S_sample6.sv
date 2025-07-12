module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    parameter STATE_A  = 4'd0; // reset state
    parameter STATE_B  = 4'd1; // f=1 pulse after reset deassert
    parameter STATE_C  = 4'd2; // wait x=1 (start sequence)
    parameter STATE_D  = 4'd3; // wait x=0 (second in sequence)
    parameter STATE_E  = 4'd4; // wait x=1 (third in sequence)
    parameter STATE_F  = 4'd5; // g=1 pulse (sequence detected)
    parameter STATE_G0 = 4'd6; // monitor y first cycle with g=1
    parameter STATE_G1 = 4'd7; // monitor y second cycle with g=1
    parameter STATE_H  = 4'd8; // permanent g=1
    parameter STATE_I  = 4'd9; // permanent g=0

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            STATE_A: begin
                if (resetn)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: next_state = STATE_C;

            STATE_C: next_state = (x == 1'b1) ? STATE_D : STATE_C;

            STATE_D: next_state = (x == 1'b0) ? STATE_E : STATE_C;

            STATE_E: next_state = (x == 1'b1) ? STATE_F : STATE_C;

            STATE_F: next_state = STATE_G0;

            STATE_G0: next_state = (y == 1'b1) ? STATE_H : STATE_G1;

            STATE_G1: next_state = (y == 1'b1) ? STATE_H : STATE_I;

            STATE_H: next_state = STATE_H;

            STATE_I: next_state = STATE_I;

            default: next_state = STATE_A;
        endcase
    end

    // Moore output logic
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case(state)
            STATE_B: f = 1'b1;
            STATE_F,
            STATE_G0,
            STATE_G1,
            STATE_H: g = 1'b1;
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule