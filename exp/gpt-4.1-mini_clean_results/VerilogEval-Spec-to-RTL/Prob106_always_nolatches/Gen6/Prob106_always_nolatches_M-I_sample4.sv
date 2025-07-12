module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    reg [3:0] arrow_vec;

    always @* begin
        case (scancode)
            16'he06b: arrow_vec = 4'b1000; // left
            16'he072: arrow_vec = 4'b0100; // down
            16'he074: arrow_vec = 4'b0010; // right
            16'he075: arrow_vec = 4'b0001; // up
            default:  arrow_vec = 4'b0000;
        endcase
    end

    assign left  = arrow_vec[3];
    assign down  = arrow_vec[2];
    assign right = arrow_vec[1];
    assign up    = arrow_vec[0];

endmodule