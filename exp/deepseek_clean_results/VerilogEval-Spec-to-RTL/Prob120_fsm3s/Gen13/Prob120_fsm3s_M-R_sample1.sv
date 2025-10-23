module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Parameterized state encoding
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] state;

    // Next state logic using continuous assignments
    wire [1:0] next_state;
    assign next_state = (state == A) ? (in ? B : A) :
                       (state == B) ? (in ? B : C) :
                       (state == C) ? (in ? D : A) :
                       (in ? B : C);  // state == D

    // State register and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 0;
        end
        else begin
            state <= next_state;
            out <= (next_state == D);
        end
    end

endmodule