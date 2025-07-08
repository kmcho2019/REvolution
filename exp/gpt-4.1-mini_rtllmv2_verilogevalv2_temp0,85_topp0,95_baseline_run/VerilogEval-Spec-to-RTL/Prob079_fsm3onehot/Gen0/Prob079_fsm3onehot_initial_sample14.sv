module TopModule(
    input        in,
    input  [3:0] state,      // one-hot encoded state
    output reg [3:0] next_state,
    output reg       out
);

    // State encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case(state)
            A: begin
                // Output is 0 in A
                out = 1'b0;
                if (in == 1'b0) next_state = A;
                else             next_state = B;
            end
            B: begin
                // Output is 0 in B
                out = 1'b0;
                if (in == 1'b0) next_state = C;
                else             next_state = B;
            end
            C: begin
                // Output is 0 in C
                out = 1'b0;
                if (in == 1'b0) next_state = A;
                else             next_state = D;
            end
            D: begin
                // Output is 1 in D
                out = 1'b1;
                if (in == 1'b0) next_state = C;
                else             next_state = B;
            end
            default: begin
                // No valid state active, keep next_state zero and output 0
                next_state = 4'b0000;
                out = 1'b0;
            end
        endcase
    end

endmodule