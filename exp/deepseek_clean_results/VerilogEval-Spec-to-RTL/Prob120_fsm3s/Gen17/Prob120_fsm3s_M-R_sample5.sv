module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b10;
    parameter [1:0] D = 2'b11;

    reg [1:0] current_state;
    wire [1:0] next_state;

    // Next state logic (combinational)
    assign next_state = 
        (current_state == A) ? (in ? B : A) :
        (current_state == B) ? (in ? B : C) :
        (current_state == C) ? (in ? D : A) :
        (current_state == D) ? (in ? B : C) : A;

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (combinational)
    assign out = (current_state == D);

endmodule