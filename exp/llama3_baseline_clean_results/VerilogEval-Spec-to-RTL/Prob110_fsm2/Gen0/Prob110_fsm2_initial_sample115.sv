module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state (0 - OFF, 1 - ON)
reg [0:0] next_state; // Next state

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

always @(posedge clk or posedge areset) begin
    if(areset) begin // Asynchronous reset
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        OFF: begin
            if(j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

assign out = state; // Output based on current state

endmodule