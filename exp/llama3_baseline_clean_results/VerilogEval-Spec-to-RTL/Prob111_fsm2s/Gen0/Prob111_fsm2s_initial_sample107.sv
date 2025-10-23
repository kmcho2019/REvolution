module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [1:0] state, next_state;

// Define states
localparam OFF = 1'b0;
localparam ON = 1'b1;

always @(*) begin
    case (state)
        OFF: begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
            out = 0;
        end
        ON: begin
            if (k)
                next_state = OFF;
            else
                next_state = ON;
            out = 1;
        end
        default: begin
            next_state = OFF;
            out = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule