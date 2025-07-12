module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

always @(*) begin
    // Default assignments
    next_state = 4'b0000;
    out = 1'b0;
    
    // State transition logic
    case (state)
        4'b0001: begin // State A
            next_state = in ? 4'b0010 : 4'b0001;
            out = 1'b0;
        end
        4'b0010: begin // State B
            next_state = in ? 4'b0010 : 4'b0100;
            out = 1'b0;
        end
        4'b0100: begin // State C
            next_state = in ? 4'b1000 : 4'b0001;
            out = 1'b0;
        end
        4'b1000: begin // State D
            next_state = in ? 4'b0010 : 4'b0100;
            out = 1'b1;
        end
        default: begin
            next_state = 4'b0000;
            out = 1'b0;
        end
    endcase
end

endmodule