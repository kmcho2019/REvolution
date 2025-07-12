module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // State variable (A = 0, B = 1)
reg [1:0] count; // Counter for clock cycles
reg [1:0] w_count; // Counter for w = 1
reg [1:0] next_state; // Next state
reg next_z; // Next output z

// Initialize state machine to state A
initial begin
    state = 0;
    count = 0;
    w_count = 0;
    z = 0;
end

always @(*) begin
    next_state = state;
    next_z = 0;
    case(state)
        0: // State A
            if(s) begin
                next_state = 1;
            end
        1: // State B
            if(count < 3) begin
                if(w) begin
                    w_count = w_count + 1;
                end
                count = count + 1;
            end else if(count == 3) begin
                if(w_count == 2) begin
                    next_z = 1;
                end
                count = 0;
                w_count = 0;
            end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        state <= next_state;
        z <= next_z;
    end
end

endmodule