module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding (2 bits)
    localparam IDLE   = 2'b00;
    localparam S1     = 2'b01;  // Got first 1
    localparam S11    = 2'b10;  // Got second 1
    localparam S110   = 2'b11;  // Got 110
    localparam FOUND  = 2'b11;  // Same encoding as S110 (mutually exclusive)

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else if (state != FOUND) begin
            case (state)
                IDLE: state <= data ? S1 : IDLE;
                S1:   state <= data ? S11 : IDLE;
                S11:  state <= data ? S11 : S110;
                S110: state <= data ? FOUND : IDLE;
            endcase
        end
    end

    assign start_shifting = (state == FOUND);

endmodule