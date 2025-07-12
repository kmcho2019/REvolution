module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] nextState;

// Next State Logic
always @(*)
begin
    case (state)
        2'b00: // State A
            begin
                if (r[0] == 1'b1)
                    nextState = 2'b01; // State B
                else if (r[1] == 1'b1)
                    nextState = 2'b10; // State C
                else if (r[2] == 1'b1)
                    nextState = 2'b11; // State D
                else
                    nextState = 2'b00; // State A
            end
        2'b01: // State B
            begin
                if (r[0] == 1'b1)
                    nextState = 2'b01; // State B
                else
                    nextState = 2'b00; // State A
            end
        2'b10: // State C
            begin
                if (r[1] == 1'b1)
                    nextState = 2'b10; // State C
                else
                    nextState = 2'b00; // State A
            end
        default: // State D
            begin
                if (r[2] == 1'b1)
                    nextState = 2'b11; // State D
                else
                    nextState = 2'b00; // State A
            end
    endcase
end

// State Flip-Flops
always @(posedge clk or negedge resetn)
begin
    if (!resetn)
        state <= 2'b00; // Reset to State A
    else
        state <= nextState;
end

// Output Logic
always @(*)
begin
    case (state)
        2'b00: // State A
            begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
        2'b01: // State B
            begin
                g[0] = 1'b1;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
        2'b10: // State C
            begin
                g[0] = 1'b0;
                g[1] = 1'b1;
                g[2] = 1'b0;
            end
        default: // State D
            begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b1;
            end
    endcase
end

endmodule