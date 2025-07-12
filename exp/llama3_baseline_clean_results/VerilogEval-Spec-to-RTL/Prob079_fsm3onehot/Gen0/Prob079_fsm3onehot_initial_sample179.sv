module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // Output logic
    assign out = (state == D) ? 1'b1 : 1'b0;

    // State transition logic
    always @(*) begin
        if (state == A) begin
            next_state = (in == 1'b0) ? A : B;
        end else if (state == B) begin
            next_state = (in == 1'b0) ? C : B;
        end else if (state == C) begin
            next_state = (in == 1'b0) ? A : D;
        end else if (state == D) begin
            next_state = (in == 1'b0) ? C : B;
        end
    end

endmodule