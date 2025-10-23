module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States representing progress through the 1101 sequence
    localparam IDLE = 0;
    localparam GOT1 = 1;
    localparam GOT11 = 2;
    localparam GOT110 = 3;
    localparam FOUND = 4;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   state <= (data) ? GOT1 : IDLE;
                GOT1:   state <= (data) ? GOT11 : IDLE;
                GOT11:  state <= (data) ? GOT11 : GOT110;
                GOT110: state <= (data) ? FOUND : IDLE;
                FOUND: state <= FOUND; // Stay in FOUND once reached
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = (state == FOUND);

endmodule