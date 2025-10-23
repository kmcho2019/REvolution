module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Shift register to store last 5 inputs
reg [4:0] history;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
    end else begin
        history <= {history[3:0], IN};
    end
end

// Compact validator FSM
localparam 
    IDLE = 1'b0,
    CHECK = 1'b1;

reg state;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: state <= (IN) ? CHECK : IDLE;
            CHECK: state <= (history[3:0] == 4'b0011) ? IDLE : CHECK;
        endcase
    end
end

// Pattern matching combinational logic
assign MATCH = (state == CHECK) && (history == 5'b10011);

endmodule