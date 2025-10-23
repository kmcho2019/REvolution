module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

// State encoding: one-hot style for easy grant mapping
localparam IDLE  = 4'b0001; // No grants
localparam GRANT0 = 4'b0010; // Grant device 0
localparam GRANT1 = 4'b0100; // Grant device 1
localparam GRANT2 = 4'b1000; // Grant device 2

reg [3:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= IDLE;
    else
        state <= next_state;
end

// Next state logic with priority on requests
always @(*) begin
    case (state)
        IDLE: begin
            if (r[0])
                next_state = GRANT0;
            else if (r[1])
                next_state = GRANT1;
            else if (r[2])
                next_state = GRANT2;
            else
                next_state = IDLE;
        end
        GRANT0: next_state = r[0] ? GRANT0 : IDLE;
        GRANT1: next_state = r[1] ? GRANT1 : IDLE;
        GRANT2: next_state = r[2] ? GRANT2 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output grant signals directly from states (one-hot)
always @(*) begin
    // g[0] = GRANT0, g[1] = GRANT1, g[2] = GRANT2
    g = 3'b000;
    if (state == GRANT0)
        g = 3'b001;
    else if (state == GRANT1)
        g = 3'b010;
    else if (state == GRANT2)
        g = 3'b100;
end

endmodule