module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // state variable to hold the current state
parameter OFF = 1'b0; // define OFF state as 0
parameter ON = 1'b1; // define ON state as 1

// handle asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= OFF; // reset to OFF state
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON; // transition from OFF to ON if j=1
                end else begin
                    state <= OFF; // stay in OFF state if j=0
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF; // transition from ON to OFF if k=1
                end else begin
                    state <= ON; // stay in ON state if k=0
                end
            end
        endcase
    end
end

// assign output based on current state
assign out = state;

endmodule