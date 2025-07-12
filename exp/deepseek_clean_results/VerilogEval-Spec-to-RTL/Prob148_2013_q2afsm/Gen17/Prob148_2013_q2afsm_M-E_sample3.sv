module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Novel state encoding:
    // [2]: 1=active grant, 0=no grant (state A)
    // [1:0]: priority encoding of current grant
    parameter [2:0] STATE_A = 3'b000;
    parameter [2:0] STATE_B = 3'b101; // g0=1 (priority 01)
    parameter [2:0] STATE_C = 3'b110; // g1=1 (priority 10)
    parameter [2:0] STATE_D = 3'b111; // g2=1 (priority 11)

    reg [2:0] current_state;

    // Priority encoder - resolves requests according to priority
    wire [1:0] priority_code;
    assign priority_code = r[0] ? 2'b01 : 
                         r[1] ? 2'b10 : 
                         r[2] ? 2'b11 : 
                         2'b00;

    // Next state logic
    wire [2:0] next_state;
    assign next_state = (!current_state[2]) ? // If in state A
                       (priority_code ? {1'b1, priority_code} : STATE_A) :
                       // Else check if current grant still asserted
                       (r[current_state[0] ? current_state : STATE_A);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Outputs are directly from state register
    assign g = (current_state == STATE_B) ? 3'b001 :
              (current_state == STATE_C) ? 3'b010 :
              (current_state == STATE_D) ? 3'b100 :
              3'b000;

endmodule