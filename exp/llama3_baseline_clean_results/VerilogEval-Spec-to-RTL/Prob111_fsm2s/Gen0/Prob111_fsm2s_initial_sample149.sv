module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
reg [0:0] state; // 0: OFF, 1: ON
localparam OFF = 1'b0;
localparam ON  = 1'b1;

always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
        endcase
    end
end

// Output is determined by the current state
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule