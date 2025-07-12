module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // state variable to store current state

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Output logic
assign out = state;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end
            end
            default: state <= OFF; // default state
        endcase
    end
end

endmodule