module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // One-hot state encoding
    localparam IDLE = 5'b10000;
    localparam S0   = 5'b00001;
    localparam S1   = 5'b00010;
    localparam S2   = 5'b00100;
    localparam S3   = 5'b01000;

    reg [4:0] state;

    // Output is high in states S0-S3
    assign shift_ena = |state[3:0];

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;  // Start counting from S0
        end else begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= IDLE;
                default: state <= IDLE;  // Stay in IDLE until reset
            endcase
        end
    end

endmodule