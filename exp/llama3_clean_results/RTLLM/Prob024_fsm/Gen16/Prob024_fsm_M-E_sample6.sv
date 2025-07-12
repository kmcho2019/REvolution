module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Prefix state machine (100)
reg [2:0] prefix_state; // 3-state state machine
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        prefix_state <= 3'b000; // Reset prefix state machine
    end else begin
        case(prefix_state)
            3'b000: if(IN) prefix_state <= 3'b001; // 0 -> 1
            3'b001: if(!IN) prefix_state <= 3'b010; // 1 -> 0
            3'b010: if(!IN) prefix_state <= 3'b011; // 0 -> 0
            3'b011: if(IN) prefix_state <= 3'b000; // 0 -> 1 (reset)
            default: prefix_state <= 3'b000; // Default state
        endcase
    end
end

// Suffix state machine (11)
reg [1:0] suffix_state; // 2-state state machine
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        suffix_state <= 2'b00; // Reset suffix state machine
    end else begin
        case(suffix_state)
            2'b00: if(IN) suffix_state <= 2'b01; // 0 -> 1
            2'b01: if(IN) suffix_state <= 2'b10; // 1 -> 1
            2'b10: if(!IN) suffix_state <= 2'b00; // 1 -> 0 (reset)
            default: suffix_state <= 2'b00; // Default state
        endcase
    end
end

// Combine prefix and suffix state machines
assign MATCH = (prefix_state == 3'b011 && suffix_state == 2'b10)? 1'b1 : 1'b0;

endmodule