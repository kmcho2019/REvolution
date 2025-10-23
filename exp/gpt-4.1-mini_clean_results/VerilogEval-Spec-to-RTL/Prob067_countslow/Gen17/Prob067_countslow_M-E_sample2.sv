module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [9:0] state;

    // next state logic
    wire [9:0] next_state;
    assign next_state = slowena ? {state[8:0], state[9]} : state; 
    // if slowena=1, rotate left by 1 bit to move to next count
    // if slowena=0, hold current state

    always @(posedge clk) begin
        if (reset) begin
            state <= 10'b0000000001; // state for count 0
        end else begin
            state <= next_state;
        end
    end

    // Decode one-hot state to binary count q
    always @(*) begin
        casez (state)
            10'b0000000001: q = 4'd0;
            10'b0000000010: q = 4'd1;
            10'b0000000100: q = 4'd2;
            10'b0000001000: q = 4'd3;
            10'b0000010000: q = 4'd4;
            10'b0000100000: q = 4'd5;
            10'b0001000000: q = 4'd6;
            10'b0010000000: q = 4'd7;
            10'b0100000000: q = 4'd8;
            10'b1000000000: q = 4'd9;
            default: q = 4'd0; // default safe state
        endcase
    end

endmodule