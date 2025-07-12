module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode states from y
    wire B = (~y[2] & ~y[1] &  y[0]);
    wire C = (~y[2] &  y[1] & ~y[0]);
    wire E = ( y[2] & ~y[1] & ~y[0]);
    wire F = ( y[2] & ~y[1] &  y[0]);

    reg next_y1;

    always @(*) begin
        next_y1 = 1'b0;
        if (B)
            next_y1 = 1'b1;
        else if (C || E)
            next_y1 = w;
        else if (F)
            next_y1 = 1'b1;
        else
            next_y1 = 1'b0;
    end

    assign Y1 = next_y1;

endmodule