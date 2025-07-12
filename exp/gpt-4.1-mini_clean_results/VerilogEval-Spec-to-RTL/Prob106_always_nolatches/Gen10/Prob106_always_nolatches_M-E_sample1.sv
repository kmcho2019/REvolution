module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Function to decode scancode into one-hot arrow key signals
    function [3:0] decode_arrow;
        input [15:0] code;
        begin
            case (code)
                16'he06b: decode_arrow = 4'b0001; // left
                16'he072: decode_arrow = 4'b0010; // down
                16'he074: decode_arrow = 4'b0100; // right
                16'he075: decode_arrow = 4'b1000; // up
                default:  decode_arrow = 4'b0000; // none
            endcase
        end
    endfunction

    wire [3:0] arrow_hot = decode_arrow(scancode);

    assign left  = arrow_hot[0];
    assign down  = arrow_hot[1];
    assign right = arrow_hot[2];
    assign up    = arrow_hot[3];

endmodule