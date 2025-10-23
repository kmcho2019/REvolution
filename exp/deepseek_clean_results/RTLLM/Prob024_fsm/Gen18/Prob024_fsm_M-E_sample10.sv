module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

reg [4:0] history;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
    end else begin
        history <= {history[3:0], IN};  // Shift in new bit
    end
end

assign MATCH = (history == 5'b10011);  // Combinational match detection

endmodule