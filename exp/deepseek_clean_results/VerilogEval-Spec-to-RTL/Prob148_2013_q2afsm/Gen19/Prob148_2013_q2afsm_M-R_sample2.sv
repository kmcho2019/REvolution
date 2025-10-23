module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding using localparam for better readability
    localparam [2:0] STATE_A = 3'b000; // No grant
    localparam [2:0] STATE_B = 3'b001; // g0 granted
    localparam [2:0] STATE_C = 3'b010; // g1 granted
    localparam [2:0] STATE_D = 3'b100; // g2 granted

    reg [2:0] current_state, next_state;

    // Function to determine highest priority request
    function [2:0] get_priority_grant;
        input [2:0] requests;
        begin
            casez (requests)
                3'b??1: get_priority_grant = STATE_B; // r[0] has highest priority
                3'b?10: get_priority_grant = STATE_C; // then r[1]
                3'b100: get_priority_grant = STATE_D; // then r[2]
                default: get_priority_grant = STATE_A; // no requests
            endcase
        end
    endfunction

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            STATE_A: next_state = get_priority_grant(r);
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignments (direct from state bits)
    assign g = current_state;

endmodule