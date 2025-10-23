module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Define states
localparam NORMAL = 1'b0;
localparam RESET  = 1'b1;

reg state;

always @(posedge clk) begin
    case (state)
        NORMAL: begin
            q <= d;
            state <= r ? RESET : NORMAL;
        end
        RESET: begin
            q <= 1'b0;
            state <= r ? RESET : NORMAL;
        end
        default: begin
            q <= 1'b0;
            state <= NORMAL;
        end
    endcase
end

endmodule