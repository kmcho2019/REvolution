module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits)
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state;

    // Next state logic as a function
    wire [1:0] next_state = (state == A) ? 
                            (r[0] ? B : (r[1] ? C : (r[2] ? D : A))) :
                            (state == B) ? (r[0] ? B : A) :
                            (state == C) ? (r[1] ? C : A) :
                            (state == D) ? (r[2] ? D : A) : A;

    // Output logic from state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 : 3'b000;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

endmodule