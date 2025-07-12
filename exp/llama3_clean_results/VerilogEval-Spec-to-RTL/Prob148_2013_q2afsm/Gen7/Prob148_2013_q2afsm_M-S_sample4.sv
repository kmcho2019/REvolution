module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10
reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(*)
begin
    case (state)
        2'b00:  // State A
            next_state = (r[0] ? 2'b01 : (r[1] ? 2'b10 : 2'b00));
        2'b01:  // State B
            next_state = r[0] ? 2'b01 : 2'b00;
        2'b10:  // State C
            next_state = r[1] ? 2'b10 : 2'b00;
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

// State register and output logic
always @(posedge clk)
begin
    if (~resetn)
    begin
        state <= 2'b00;  // Reset to state A
        g[0] <= 0;
        g[1] <= 0;
        g[2] <= 0;
    end
    else
    begin
        state <= next_state;
        case (next_state)
            2'b00:  // State A
            begin
                g[0] <= 0;
                g[1] <= 0;
                g[2] <= (r[2] && !r[0] && !r[1]);
            end
            2'b01:  // State B
            begin
                g[0] <= 1;
                g[1] <= 0;
                g[2] <= 0;
            end
            2'b10:  // State C
            begin
                g[0] <= 0;
                g[1] <= 1;
                g[2] <= 0;
            end
            default:
            begin
                g[0] <= 0;
                g[1] <= 0;
                g[2] <= 0;
            end
        endcase
    end
end

endmodule