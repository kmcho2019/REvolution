module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Binary state encoding
    localparam [2:0] 
        IDLE   = 3'b000,
        S1     = 3'b001,  // Got first 1
        S11    = 3'b010,  // Got 11
        S110   = 3'b011,  // Got 110
        FOUND  = 3'b100;  // Got 1101

    reg [2:0] state;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= data ? S1 : IDLE;
                S1:    state <= data ? S11 : IDLE;
                S11:   state <= data ? S11 : S110;
                S110:  state <= data ? FOUND : IDLE;
                FOUND: state <= FOUND;
                default: state <= IDLE;
            endcase
        end
    end

    // Output is high only in FOUND state
    assign start_shifting = (state == FOUND);

endmodule