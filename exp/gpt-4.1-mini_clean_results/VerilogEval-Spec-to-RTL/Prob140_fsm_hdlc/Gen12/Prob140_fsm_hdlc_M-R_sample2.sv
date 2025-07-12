module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: one-hot style represented as a 3-bit binary count (0 to 7)
    reg [2:0] state, next_state;

    // Combinational logic for next state
    // If input is 1, move to next higher count, saturate at 7
    // If input is 0, reset count to 0
    wire [2:0] next_state_calc = in ? ((state < 3'd7) ? (state + 3'd1) : 3'd7) : 3'd0;

    // Outputs depend on current state and input (Moore outputs)
    wire disc_w = (state == 3'd5) && (in == 1'b0);
    wire flag_w = (state == 3'd6) && (in == 1'b0);
    wire err_w  = (next_state_calc == 3'd7);

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state_calc;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule