module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Internal one-hot encoded output vector
    reg [3:0] arrow_flags;

    always @* begin
        arrow_flags = 4'b0000; // Default no arrow pressed

        if (scancode[15:8] == 8'hE0) begin
            case (scancode[7:0])
                8'h6B: arrow_flags = 4'b1000; // left
                8'h72: arrow_flags = 4'b0100; // down
                8'h74: arrow_flags = 4'b0010; // right
                8'h75: arrow_flags = 4'b0001; // up
                default: arrow_flags = 4'b0000;
            endcase
        end
    end

    // Assign outputs from the one-hot encoded vector
    assign left  = arrow_flags[3];
    assign down  = arrow_flags[2];
    assign right = arrow_flags[1];
    assign up    = arrow_flags[0];

endmodule