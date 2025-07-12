module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam GOT1    = 4'b0010;
    localparam GOT11   = 4'b0100;
    localparam GOT110  = 4'b1000;

    reg [3:0] state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   state <= (data) ? GOT1 : IDLE;
                GOT1:   state <= (data) ? GOT11 : IDLE;
                GOT11:  state <= (data) ? GOT11 : GOT110;
                GOT110: state <= (data) ? IDLE : IDLE; // On 1101, stay in final state
                default: state <= IDLE;
            endcase
        end
    end

    // Output is high when we reach GOT110 and see a 1 (1101 complete)
    assign start_shifting = (state == GOT110) && data;

endmodule