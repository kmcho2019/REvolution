module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with parameters
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next state logic
    assign next_state = (state == A) ? (in ? B : A) :
                       (state == B) ? (in ? B : C) :
                       (state == C) ? (in ? D : A) :
                       (in ? B : C); // state == D

    // Sequential state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state == D);

endmodule