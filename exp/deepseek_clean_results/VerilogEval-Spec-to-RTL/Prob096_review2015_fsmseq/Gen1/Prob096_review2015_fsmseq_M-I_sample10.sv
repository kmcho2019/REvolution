module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam [4:0] 
        IDLE   = 5'b00001,
        GOT1   = 5'b00010,
        GOT11  = 5'b00100,
        GOT110 = 5'b01000,
        FOUND  = 5'b10000;

    reg [4:0] current_state, next_state;
    wire clk_gated;

    // Clock gating when in FOUND state
    assign clk_gated = (current_state != FOUND) ? clk : 1'b0;

    // State register (sequential logic with clock gating)
    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : GOT110;
            GOT110: next_state = data ? FOUND : IDLE;
            FOUND:  next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    // Registered output for better timing
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else begin
            start_shifting <= (next_state == FOUND);
        end
    end

endmodule