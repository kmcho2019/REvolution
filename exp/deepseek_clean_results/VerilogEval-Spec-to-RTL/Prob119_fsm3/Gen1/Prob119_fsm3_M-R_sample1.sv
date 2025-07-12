module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    reg [3:0] current_state;

    // Next state wires
    wire [3:0] next_A, next_B, next_C, next_D;

    // State transition logic using continuous assignments
    assign next_A = (current_state == A) ? (in ? B : A) : 4'b0;
    assign next_B = (current_state == B) ? (in ? B : C) : 4'b0;
    assign next_C = (current_state == C) ? (in ? D : A) : 4'b0;
    assign next_D = (current_state == D) ? (in ? B : C) : 4'b0;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_A | next_B | next_C | next_D;
        end
    end

    // Output logic
    assign out = (current_state == D);

endmodule