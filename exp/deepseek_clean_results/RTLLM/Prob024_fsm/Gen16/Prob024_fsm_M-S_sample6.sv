module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions with minimal encoding
localparam [1:0]
    IDLE  = 2'b00,
    GOT1  = 2'b01,
    GOT10 = 2'b10;

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        MATCH <= 1'b0; // Default output
        case (state)
            IDLE:  if (IN) begin
                       state <= GOT1;
                   end
            GOT1:  if (!IN) begin
                       state <= GOT10;
                   end else begin
                       state <= GOT1;
                   end
            GOT10: if (IN) begin
                       state <= GOT1;
                       MATCH <= 1'b1; // Sequence 1001 detected
                   end else begin
                       state <= GOT10;
                   end
            default: state <= IDLE;
        endcase
    end
end

endmodule