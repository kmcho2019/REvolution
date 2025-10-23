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
            if (r) state <= RESET;
        end
        RESET: begin
            q <= 1'b0;
            if (!r) state <= NORMAL;
        end
    endcase
end

// Initialize state
initial begin
    state = NORMAL;
    q = 1'b0;
end

endmodule