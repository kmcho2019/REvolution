module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding
    localparam STATE_A  = 2'b00;
    localparam STATE_G0 = 2'b01;
    localparam STATE_G1 = 2'b10;
    localparam STATE_G2 = 2'b11;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (r[0])       next_state = STATE_G0;
                else if (r[1])   next_state = STATE_G1;
                else if (r[2])   next_state = STATE_G2;
                else            next_state = STATE_A;
            end
            STATE_G0: next_state = r[0] ? STATE_G0 : STATE_A;
            STATE_G1: next_state = r[1] ? STATE_G1 : STATE_A;
            STATE_G2: next_state = r[2] ? STATE_G2 : STATE_A;
            default:   next_state = STATE_A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= STATE_A;
        else state <= next_state;
    end

    // Output logic
    assign g[0] = (state == STATE_G0);
    assign g[1] = (state == STATE_G1);
    assign g[2] = (state == STATE_G2);

endmodule