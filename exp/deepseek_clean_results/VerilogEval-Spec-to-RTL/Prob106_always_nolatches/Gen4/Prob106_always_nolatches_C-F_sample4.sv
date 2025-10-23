module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // First check if it's an extended key (0xe0 prefix)
    wire is_extended = (scancode[15:8] == 8'he0);
    
    // Decode arrow keys using case statement for clarity and extensibility
    // Outputs are mutually exclusive by design
    always @(*) begin
        if (is_extended) begin
            case (scancode[7:0])
                8'h6b: {left, down, right, up} = 4'b1000; // Left arrow
                8'h72: {left, down, right, up} = 4'b0100; // Down arrow
                8'h74: {left, down, right, up} = 4'b0010; // Right arrow
                8'h75: {left, down, right, up} = 4'b0001; // Up arrow
                default: {left, down, right, up} = 4'b0000; // Not an arrow key
            endcase
        end else begin
            {left, down, right, up} = 4'b0000; // Not an extended key
        end
    end

endmodule