module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Division factor, must be an even number

// Ensure NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

reg [3:0] cnt; // 4-bit counter
reg [1:0] state; // FSM states: 2'b00 - IDLE, 2'b01 - COUNT, 2'b10 - TOGGLE

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        state <= 2'b00; // IDLE state
        clk_div <= 1'b0;
    end else begin
        case(state)
            2'b00: // IDLE state, go to COUNT state immediately
                state <= 2'b01;
            2'b01: // COUNT state
                if (cnt < (NUM_DIV / 2 - 1)) begin
                    cnt <= cnt + 1;
                end else begin
                    state <= 2'b10; // Transition to TOGGLE state
                end
            2'b10: // TOGGLE state
                begin
                    cnt <= 4'd0; // Reset counter
                    state <= 2'b01; // Back to COUNT state
                    clk_div <= ~clk_div; // Toggle divided clock
                end
        endcase
    end
end

endmodule