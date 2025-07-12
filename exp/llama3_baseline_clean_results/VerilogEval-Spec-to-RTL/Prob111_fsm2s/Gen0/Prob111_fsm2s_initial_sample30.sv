module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 0, ON = 1;

// State register
reg [0:0] state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        OFF: out = 0;
        ON: out = 1;
    endcase
end

endmodule