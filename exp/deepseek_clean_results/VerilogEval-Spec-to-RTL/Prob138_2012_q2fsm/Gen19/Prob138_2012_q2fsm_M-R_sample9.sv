module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding with descriptive parameter names
    localparam [2:0] 
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b011,
        STATE_D = 3'b010,
        STATE_E = 3'b111,
        STATE_F = 3'b110;

    reg [2:0] current_state;

    // Parallel state transition logic using ternary operators
    wire [2:0] next_state = 
        (current_state == STATE_A) ? (w ? STATE_B : STATE_A) :
        (current_state == STATE_B) ? (w ? STATE_C : STATE_D) :
        (current_state == STATE_C) ? (w ? STATE_E : STATE_D) :
        (current_state == STATE_D) ? (w ? STATE_F : STATE_A) :
        (current_state == STATE_E) ? (w ? STATE_E : STATE_D) :
        (current_state == STATE_F) ? (w ? STATE_C : STATE_D) :
        STATE_A;  // Default case

    // State storage with synchronous reset
    always @(posedge clk) begin
        current_state <= reset ? STATE_A : next_state;
    end

    // Output logic - explicit check for states with z=1 (E and F)
    assign z = (current_state == STATE_E) || (current_state == STATE_F);

endmodule