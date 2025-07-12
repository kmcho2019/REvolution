module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray code state encoding
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    D = 2'b11,
                    C = 2'b10;

    reg [1:0] state, next_state;

    // Combinational next-state logic
    assign next_state = (state == A) ? (in ? B : A) :
                       (state == B) ? (in ? B : C) :
                       (state == C) ? (in ? D : A) :
                       (in ? B : C);  // state == D

    // Sequential state update
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