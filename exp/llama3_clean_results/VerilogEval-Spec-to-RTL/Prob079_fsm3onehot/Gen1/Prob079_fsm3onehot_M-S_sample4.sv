module TopModule(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    always @(*) begin
        case (state)
            4'b0001: // State A
                next_state = in ? 4'b0010 : 4'b0001;
            4'b0010: // State B
                next_state = in ? 4'b0010 : 4'b0100;
            4'b0100: // State C
                next_state = in ? 4'b1000 : 4'b0001;
            4'b1000: // State D
                next_state = in ? 4'b0010 : 4'b0100;
            default: // Invalid state
                next_state = 4'b0000;
        endcase
        
        // Output logic
        out = (state == 4'b1000) ? 1'b1 : 1'b0;
    end

endmodule