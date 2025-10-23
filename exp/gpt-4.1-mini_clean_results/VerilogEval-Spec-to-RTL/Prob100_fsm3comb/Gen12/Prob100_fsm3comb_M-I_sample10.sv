module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(*) begin
        // Default assignments
        next_state = A;
        out = 1'b0;

        if (state == A) begin
            next_state = in ? B : A;
            out = 1'b0;
        end
        else if (state == B) begin
            next_state = in ? B : C;
            out = 1'b0;
        end
        else if (state == C) begin
            next_state = in ? D : A;
            out = 1'b0;
        end
        else if (state == D) begin
            next_state = in ? B : C;
            out = 1'b1;
        end
        else begin
            // Default state handling
            next_state = A;
            out = 1'b0;
        end
    end

endmodule