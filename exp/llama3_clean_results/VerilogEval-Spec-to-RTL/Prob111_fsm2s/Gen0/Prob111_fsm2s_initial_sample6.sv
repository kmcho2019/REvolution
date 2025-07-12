module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] next_state; // 1-bit signal to represent the next state

always @(*) begin
    case(state)
        1'b0: begin // OFF state
            if(j == 1'b1) begin
                next_state = 1'b1; // transition to ON state
            end else begin
                next_state = 1'b0; // stay in OFF state
            end
        end
        1'b1: begin // ON state
            if(k == 1'b1) begin
                next_state = 1'b0; // transition to OFF state
            end else begin
                next_state = 1'b1; // stay in ON state
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        state <= 1'b0; // reset to OFF state
    end else begin
        state <= next_state;
    end
end

assign out = state; // output is the current state

endmodule