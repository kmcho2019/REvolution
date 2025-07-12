module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State wires
    wire [1:0] current_state;
    wire [1:0] next_state;

    // Next state combinational logic
    assign next_state = 
        (current_state == A) ? (in ? B : A) :
        (current_state == B) ? (in ? B : C) :
        (current_state == C) ? (in ? D : A) :
        (current_state == D) ? (in ? B : C) : A;

    // State register (D-flip-flop with async reset)
    dff_async_reset #(2) state_reg (
        .clk(clk),
        .reset(areset),
        .d(next_state),
        .q(current_state),
        .reset_val(A)
    );

    // Output logic
    assign out = (current_state == D);

endmodule

// D-flip-flop with asynchronous reset module
module dff_async_reset #(parameter WIDTH = 1) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    input [WIDTH-1:0] reset_val
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= reset_val;
        else
            q <= d;
    end
endmodule