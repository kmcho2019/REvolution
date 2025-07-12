module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // 1-bit state register
reg [0:0] next_state;

// Define states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Output logic
assign out = state;

// Next state logic
always @(state, j, k) begin
    case(state)
        OFF: begin
            if(j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if(k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule