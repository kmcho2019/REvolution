module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT1   = 2'b01;
localparam [1:0] GOT10  = 2'b10;
localparam [1:0] GOT100 = 2'b11;

reg [1:0] current_state, next_state;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        IDLE:   begin
            next_state = IN ? GOT1 : IDLE;
            MATCH = 1'b0;
        end
        GOT1:   begin
            next_state = IN ? GOT1 : GOT10;
            MATCH = 1'b0;
        end
        GOT10:  begin
            next_state = IN ? GOT1 : GOT100;
            MATCH = 1'b0;
        end
        GOT100: begin
            next_state = IN ? GOT1 : GOT10;
            MATCH = IN;  // Output 1 when in GOT100 state and IN=1
        end
    endcase
end

endmodule