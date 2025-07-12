module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // One-hot state encoding
    localparam IDLE = 5'b00001;
    localparam S1   = 5'b00010;
    localparam S2   = 5'b00100;
    localparam S3   = 5'b01000;
    localparam S4   = 5'b10000;

    reg [4:0] state;

    assign shift_ena = (state != IDLE);

    always @(posedge clk) begin
        if (reset) begin
            state <= S1;  // Start sequence on reset
        end else begin
            case (state)
                IDLE: state <= IDLE;  // Stay idle until reset
                S1:   state <= S2;
                S2:   state <= S3;
                S3:   state <= S4;
                S4:   state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

endmodule