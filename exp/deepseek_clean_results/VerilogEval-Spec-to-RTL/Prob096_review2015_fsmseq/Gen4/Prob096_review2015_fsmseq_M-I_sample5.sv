module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding (2 bits for 5 states)
    localparam IDLE   = 2'b00;
    localparam GOT1   = 2'b01;
    localparam GOT11  = 2'b10;
    localparam GOT110 = 2'b11;
    localparam FOUND  = 2'b11; // Same as GOT110 but differentiated by logic

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= data ? GOT1 : IDLE;
                    start_shifting <= 1'b0;
                end
                GOT1: begin
                    state <= data ? GOT11 : IDLE;
                    start_shifting <= 1'b0;
                end
                GOT11: begin
                    state <= data ? GOT11 : GOT110;
                    start_shifting <= 1'b0;
                end
                GOT110: begin
                    state <= data ? FOUND : IDLE;
                    start_shifting <= data ? 1'b1 : 1'b0;
                end
                FOUND: begin
                    state <= FOUND;
                    start_shifting <= 1'b1;
                end
            endcase
        end
    end

endmodule