module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Function to determine next y[1] bit based on current state (y2,y1,y0) and input w
    function logic get_next_y1(input logic y2, input logic y1, input logic y0, input logic w);
        begin
            // State encodings for readability
            // A=000, B=001, C=010, D=011, E=100, F=101

            if (~y2 & ~y1 & y0) begin
                // B (001): next y1 always 1
                get_next_y1 = 1'b1;
            end else if (~y2 & y1 & ~y0) begin
                // C (010): next y1 = w
                get_next_y1 = w;
            end else if (y2 & ~y1 & ~y0) begin
                // E (100): next y1 = w
                get_next_y1 = w;
            end else if (y2 & ~y1 & y0) begin
                // F (101): next y1 = 1
                get_next_y1 = 1'b1;
            end else begin
                // For all other states (A=000, D=011), next y1 = 0
                get_next_y1 = 1'b0;
            end
        end
    endfunction

    assign Y1 = get_next_y1(y2, y1, y0, w);

endmodule