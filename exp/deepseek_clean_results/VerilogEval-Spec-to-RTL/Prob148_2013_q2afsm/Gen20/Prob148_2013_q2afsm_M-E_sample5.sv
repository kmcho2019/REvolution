module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam STATE_A = 2'b00;  // Idle
    localparam STATE_B = 2'b01;  // Device 0 granted
    localparam STATE_C = 2'b10;  // Device 1 granted
    localparam STATE_D = 2'b11;  // Device 2 granted

    reg [1:0] current_state, next_state;

    // Parallel request evaluation with priority
    wire any_request = |r;
    wire highest_priority_req = r[0] ? 1'b1 : 
                              (r[1] ? 1'b0 : 
                              (r[2] ? 1'b1 : 1'b0));

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (!any_request) next_state = STATE_A;
                else if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else next_state = STATE_D;
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!resetn) current_state <= STATE_A;
        else current_state <= next_state;
    end

    // Output logic (combinational)
    assign g[0] = (current_state == STATE_B);
    assign g[1] = (current_state == STATE_C);
    assign g[2] = (current_state == STATE_D);

endmodule