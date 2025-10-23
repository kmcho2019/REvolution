module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // PS/2 scancode parameters for arrow keys
    parameter LEFT_SCANCODE  = 16'he06b;
    parameter DOWN_SCANCODE  = 16'he072;
    parameter RIGHT_SCANCODE = 16'he074;
    parameter UP_SCANCODE    = 16'he075;

    // Internal one-hot encoded signals
    reg [3:0] arrow_keys;
    
    always @(*) begin
        case (scancode)
            LEFT_SCANCODE:  arrow_keys = 4'b1000;
            DOWN_SCANCODE:  arrow_keys = 4'b0100;
            RIGHT_SCANCODE: arrow_keys = 4'b0010;
            UP_SCANCODE:    arrow_keys = 4'b0001;
            default:        arrow_keys = 4'b0000;
        endcase
    end

    // Assign outputs from one-hot encoding
    assign left  = arrow_keys[3];
    assign down  = arrow_keys[2];
    assign right = arrow_keys[1];
    assign up    = arrow_keys[0];

endmodule