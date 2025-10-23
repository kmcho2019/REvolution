module TopModule (
    input      in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    always @(*) begin
        // Default outputs
        next_state = 4'b0000;
        out = 1'b0;

        // State A = 4'b0001
        if (state == 4'b0001) begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = 4'b0001; // Stay in A
            else
                next_state = 4'b0010; // Go to B
        end
        // State B = 4'b0010
        else if (state == 4'b0010) begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = 4'b0100; // Go to C
            else
                next_state = 4'b0010; // Stay in B
        end
        // State C = 4'b0100
        else if (state == 4'b0100) begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = 4'b0001; // Go to A
            else
                next_state = 4'b1000; // Go to D
        end
        // State D = 4'b1000
        else if (state == 4'b1000) begin
            out = 1'b1;
            if (in == 1'b0)
                next_state = 4'b0100; // Go to C
            else
                next_state = 4'b0010; // Go to B
        end
        else begin
            // Undefined state: default to A and output 0
            next_state = 4'b0001;
            out = 1'b0;
        end
    end

endmodule