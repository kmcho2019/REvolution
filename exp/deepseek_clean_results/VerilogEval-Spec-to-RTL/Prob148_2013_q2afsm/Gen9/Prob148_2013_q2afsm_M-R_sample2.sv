module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam [3:0] STATE_A = 4'b0001;
    localparam [3:0] STATE_B = 4'b0010;
    localparam [3:0] STATE_C = 4'b0100;
    localparam [3:0] STATE_D = 4'b1000;
    
    reg [3:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= STATE_A;
        else state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else if (r[2]) next_state = STATE_D;
                else next_state = STATE_A;
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // Output logic - direct mapping from state bits
    assign g[0] = (state == STATE_B);
    assign g[1] = (state == STATE_C);
    assign g[2] = (state == STATE_D);

endmodule