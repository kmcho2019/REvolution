module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State parameters
    localparam [2:0] STATE_A = 3'b000; // No grant
    localparam [2:0] STATE_B = 3'b001; // g0 granted
    localparam [2:0] STATE_C = 3'b010; // g1 granted
    localparam [2:0] STATE_D = 3'b100; // g2 granted

    reg [2:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= (state == STATE_A) ? 
                    (r[0] ? STATE_B : 
                    (r[1] ? STATE_C : 
                    (r[2] ? STATE_D : STATE_A))) :
                    // For granted states, maintain if request still active
                    ((state == STATE_B) ? (r[0] ? STATE_B : STATE_A) :
                    ((state == STATE_C) ? (r[1] ? STATE_C : STATE_A) :
                    ((state == STATE_D) ? (r[2] ? STATE_D : STATE_A) : STATE_A));
        end
    end

    // Output assignments - combinatorial
    assign g = state;

endmodule