module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State definitions
localparam HOLD = 1'b0;
localparam COUNT = 1'b1;
reg state;

always @(posedge clk) begin
    case (state)
        HOLD: begin
            q <= 3'd4;
            if (!a) state <= COUNT;
        end
        COUNT: begin
            q <= (q == 3'd6) ? 3'd0 : q + 1;
            if (a) state <= HOLD;
        end
    endcase
end

// Initial state (optional but good practice)
initial begin
    state = HOLD;
    q = 3'd4;
end

endmodule