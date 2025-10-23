module TopModule (
    input  in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    always @(*) begin
        if (A) begin
            // From A: next_state = A if in=0 else B if in=1
            next_state = in ? 4'b0010 : 4'b0001;
        end else if (B) begin
            // From B: next_state = C if in=0 else B if in=1
            next_state = in ? 4'b0010 : 4'b0100;
        end else if (C) begin
            // From C: next_state = A if in=0 else D if in=1
            next_state = in ? 4'b1000 : 4'b0001;
        end else if (D) begin
            // From D: next_state = C if in=0 else B if in=1
            next_state = in ? 4'b0010 : 4'b0100;
        end else begin
            // Default: no state active
            next_state = 4'b0000;
        end
    end

    assign out = D;

endmodule