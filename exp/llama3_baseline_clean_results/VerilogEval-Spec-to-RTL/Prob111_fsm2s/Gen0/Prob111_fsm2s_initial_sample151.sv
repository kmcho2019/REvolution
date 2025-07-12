module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] current_state; // 0: OFF, 1: ON
parameter OFF = 0, ON = 1;

always @(posedge clk) begin
    if(reset) begin // synchronous reset
        current_state <= OFF;
    end else begin
        case(current_state)
            OFF: begin
                if(j == 1) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if(k == 1) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
        endcase
    end
end

// Moore output (output depends on current state)
assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule