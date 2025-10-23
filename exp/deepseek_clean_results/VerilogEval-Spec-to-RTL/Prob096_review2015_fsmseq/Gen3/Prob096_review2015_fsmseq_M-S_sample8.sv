module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Reduced state encoding
    reg [1:0] state;

    // State definitions
    localparam IDLE = 2'b00;
    localparam S1   = 2'b01;
    localparam S2   = 2'b10;
    localparam S3   = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 0;
        end else begin
            case (state)
                IDLE: begin
                    start_shifting <= 0;
                    state <= data ? S1 : IDLE;
                end
                S1: begin
                    start_shifting <= 0;
                    state <= data ? S2 : IDLE;
                end
                S2: begin
                    start_shifting <= 0;
                    state <= data ? S2 : S3;
                end
                S3: begin
                    start_shifting <= data;
                    state <= data ? IDLE : IDLE; // FOUND is implied by start_shifting
                end
                default: begin
                    start_shifting <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule