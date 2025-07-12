module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // One-hot state register: 10 bits for states 1 to 10
    reg [9:0] state;

    // Next state logic: rotate one-hot
    wire [9:0] next_state = {state[8:0], state[9]};

    // Decode one-hot state to binary count 1-10
    // Use a priority encoder style or case statement
    always @(*) begin
        casez (state)
            10'b0000000001: q = 4'd1;
            10'b0000000010: q = 4'd2;
            10'b0000000100: q = 4'd3;
            10'b0000001000: q = 4'd4;
            10'b0000010000: q = 4'd5;
            10'b0000100000: q = 4'd6;
            10'b0001000000: q = 4'd7;
            10'b0010000000: q = 4'd8;
            10'b0100000000: q = 4'd9;
            10'b1000000000: q = 4'd10;
            default:       q = 4'd1; // Default safe state
        endcase
    end

    // State update on positive edge of clk, synchronous reset active high
    always @(posedge clk) begin
        if (reset) begin
            // Reset to state 1 (bit 0 high)
            state <= 10'b0000000001;
        end else begin
            state <= next_state;
        end
    end

endmodule