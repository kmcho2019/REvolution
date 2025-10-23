module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray code state encoding with enum-style parameters
    // States with z=1: E(6), F(7) - these have bit 2 set
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b111;

    // State transition function
    function [2:0] next_state_func;
        input [2:0] current;
        input w;
        begin
            case (current)
                A: next_state_func = w ? B : A;
                B: next_state_func = w ? C : D;
                C: next_state_func = w ? E : D;
                D: next_state_func = w ? F : A;
                E: next_state_func = w ? E : D;
                F: next_state_func = w ? C : D;
                default: next_state_func = A;
            endcase
        end
    endfunction

    reg [2:0] current_state;
    
    // State register with synchronous reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state_func(current_state, w);
    end

    // Output z is the MSB of state (E and F have this bit set)
    assign z = current_state[2];

endmodule