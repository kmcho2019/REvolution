module TopModule #(
    parameter ENABLE_BUFFERING = 0
) (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    generate
        if (ENABLE_BUFFERING) begin
            // Buffered assignments - can add delay or drive strength later here
            wire w_buf, x_buf, y_buf, z_buf;

            assign w_buf = a;
            assign x_buf = b;
            assign y_buf = b;
            assign z_buf = c;

            assign w = w_buf;
            assign x = x_buf;
            assign y = y_buf;
            assign z = z_buf;

        end else begin
            // Direct wiring for minimal area/power
            assign w = a;
            assign x = b;
            assign y = b;
            assign z = c;
        end
    endgenerate

endmodule