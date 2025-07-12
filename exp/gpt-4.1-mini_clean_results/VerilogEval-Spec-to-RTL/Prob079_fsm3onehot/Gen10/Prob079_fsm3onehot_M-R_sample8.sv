module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    // Decode one-hot states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    always @(*) begin
        // Default assignments to zero for safety
        next_state = 4'b0000;
        out = 1'b0;

        if (A) begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b0010; // B
        end
        else if (B) begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
        end
        else if (C) begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b1000; // D
        end
        else if (D) begin
            out = 1'b1;
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
        end
        else begin
            // Undefined state: optionally keep next_state zero
            next_state = 4'b0000;
            out = 1'b0;
        end
    end

endmodule