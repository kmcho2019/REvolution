module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// States for sequence detection
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT10X = 2'b10;  // Tracks both GOT10 and GOT100 states

reg [1:0] current_state, next_state;
reg zero_count;  // Tracks number of zeros seen (0 or 1)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        zero_count <= 1'b0;
    end else begin
        current_state <= next_state;
        // Update zero counter when in GOT10X state
        if (current_state == GOT10X && !IN)
            zero_count <= ~zero_count;
        else
            zero_count <= 1'b0;
    end
end

// Next state and output logic
always @(*) begin
    MATCH = 1'b0;
    case (current_state)
        IDLE: begin
            next_state = IN ? GOT1 : IDLE;
        end
        GOT1: begin
            next_state = IN ? GOT1 : GOT10X;
        end
        GOT10X: begin
            if (IN) begin
                if (zero_count) begin  // Seen two zeros before this 1
                    MATCH = 1'b1;      // Output match on last 1
                    next_state = GOT1; // Start new sequence
                end else begin
                    next_state = GOT1;
                end
            end else begin
                next_state = GOT10X;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule