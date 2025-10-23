module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            4'b0001: begin // State A
                if (in == 1'b0) begin
                    next_state = 4'b0001; // A
                end else begin
                    next_state = 4'b0010; // B
                end
                out = 1'b0;
            end
            4'b0010: begin // State B
                if (in == 1'b0) begin
                    next_state = 4'b0100; // C
                end else begin
                    next_state = 4'b0010; // B
                end
                out = 1'b0;
            end
            4'b0100: begin // State C
                if (in == 1'b0) begin
                    next_state = 4'b0001; // A
                end else begin
                    next_state = 4'b1000; // D
                end
                out = 1'b0;
            end
            4'b1000: begin // State D
                if (in == 1'b0) begin
                    next_state = 4'b0100; // C
                end else begin
                    next_state = 4'b0010; // B
                end
                out = 1'b1;
            end
            default: begin
                // Invalid state, default to A with output 0
                next_state = 4'b0001;
                out = 1'b0;
            end
        endcase
    end

endmodule