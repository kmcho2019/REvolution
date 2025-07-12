module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Internal one-hot encoded representation
    reg [3:0] arrow_keys;
    
    always @(*) begin
        // Default: no keys pressed
        arrow_keys = 4'b0000;
        
        // Check for arrow key prefix first
        if (scancode[15:8] == 8'he0) begin
            case (scancode[7:0])
                8'h6b: arrow_keys = 4'b1000; // left
                8'h72: arrow_keys = 4'b0100; // down
                8'h74: arrow_keys = 4'b0010; // right
                8'h75: arrow_keys = 4'b0001; // up
                default: ; // No arrow key pressed
            endcase
        end
    end

    // Assign outputs from one-hot encoded register
    assign {left, down, right, up} = arrow_keys;

endmodule