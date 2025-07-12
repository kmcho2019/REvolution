module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding
    localparam IDLE   = 5'b00001;
    localparam GOT1   = 5'b00010;
    localparam GOT11  = 5'b00100;
    localparam GOT110 = 5'b01000;
    localparam FOUND  = 5'b10000;

    reg [4:0] state;

    // State transitions and output
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   state <= data ? GOT1 : IDLE;
                GOT1:   state <= data ? GOT11 : IDLE;
                GOT11:  state <= data ? GOT11 : GOT110;
                GOT110: state <= data ? FOUND : IDLE;
                FOUND:  state <= FOUND; // Stay here until reset
                default:state <= IDLE;
            endcase
        end
    end

    // Output is high only in FOUND state
    assign start_shifting = state[4]; // MSB is FOUND state

endmodule