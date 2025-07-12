module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // One-hot state encoding
    localparam IDLE = 5'b00000;
    localparam S1   = 5'b00001;
    localparam S2   = 5'b00010;
    localparam S3   = 5'b00100;
    localparam S4   = 5'b01000;

    reg [4:0] state;

    // Output is high in states S1-S4
    assign shift_ena = |state[3:0];

    always @(posedge clk) begin
        if (reset) begin
            state <= S1;  // Start counting on reset
        end else begin
            case (state)
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S4;
                S4: state <= IDLE;
                default: state <= IDLE;  // Stay in IDLE until reset
            endcase
        end
    end

endmodule