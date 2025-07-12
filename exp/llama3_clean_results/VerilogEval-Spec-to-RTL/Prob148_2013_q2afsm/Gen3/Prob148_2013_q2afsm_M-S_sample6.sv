module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to State A
    end else begin
        case (state)
            2'b00: // State A
                if (r[0]) begin
                    state <= 2'b01; // State B
                end else if (r[1]) begin
                    state <= 2'b10; // State C
                end else if (r[2]) begin
                    state <= 2'b11; // State D
                end else begin
                    state <= 2'b00; // State A
                end
            2'b01: // State B
                if (r[0]) begin
                    state <= 2'b01; // State B
                end else begin
                    state <= 2'b00; // State A
                end
            2'b10: // State C
                if (r[1]) begin
                    state <= 2'b10; // State C
                end else begin
                    state <= 2'b00; // State A
                end
            2'b11: // State D
                if (r[2]) begin
                    state <= 2'b11; // State D
                end else begin
                    state <= 2'b00; // State A
                end
            default:
                state <= 2'b00; // State A
        endcase
    end

    // FSM outputs
    case (state)
        2'b00: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        2'b01: begin
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        2'b10: begin
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        end
        2'b11: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b1;
        end
        default: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
    endcase
end

endmodule