module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    always @(*) begin
        // Default all outputs to 0
        {left, down, right, up} = 4'b0000;
        
        case (scancode)
            16'he06b: left = 1'b1;   // Left arrow
            16'he072: down = 1'b1;   // Down arrow
            16'he074: right = 1'b1;  // Right arrow
            16'he075: up = 1'b1;     // Up arrow
        endcase
    end

endmodule