module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding using Gray coding
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] current_state;
    wire [2:0] next_state;

    // Next state logic using continuous assignments
    assign next_state = 
        (current_state == A) ? (w ? A : B) :
        (current_state == B) ? (w ? D : C) :
        (current_state == C) ? (w ? D : E) :
        (current_state == D) ? (w ? A : F) :
        (current_state == E) ? (w ? D : E) :
        (current_state == F) ? (w ? D : C) :
        A;  // Default case (should never be reached)

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - MSB indicates z
    assign z = current_state[2];

endmodule