module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg; // Register to hold the current state
assign state = stateReg; // Output the current state

// Combinational logic for q
assign q = (b) || (a && !b);

// Combinational logic for next_state
always @(*) begin
    if (!a && !b) begin
        stateReg = 1'b1;
    end else if ((stateReg == 1'b1) && (a || b)) begin
        stateReg = 1'b0;
    end else begin
        stateReg = stateReg;
    end
end

// Positive edge triggered flip-flop
always @(posedge clk) begin
    if (!a && !b) begin
        stateReg <= 1'b1;
    end else if ((stateReg == 1'b1) && (a || b)) begin
        stateReg <= 1'b0;
    end else begin
        stateReg <= stateReg;
    end
end

endmodule